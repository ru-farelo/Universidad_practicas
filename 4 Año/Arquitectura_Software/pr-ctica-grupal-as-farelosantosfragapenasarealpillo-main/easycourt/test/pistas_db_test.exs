defmodule PistasDataBaseTest do
  @moduledoc """
  **PistasDataBaseTest** es un módulo que contiene un conjunto de casos de prueba para probar
  la funcionalidad de los módulos `TablaPistas` y `TablaUsuarios` en la base de datos.

  Las pruebas incluyen escenarios para:
  - Inicializar los datos de las pistas.
  - Reservar, liberar y listar las reservas de las pistas.
  - Manejar errores para acciones no válidas en pistas y usuarios.

  ## Configuración
  Antes de cada prueba, se realiza la siguiente configuración:
  - Se llama a `TablaPistas.start_link()` para inicializar la base de datos de pistas.
  - Se llama a `TablaUsuarios.start_link()` para inicializar la base de datos de usuarios.

  ## Ejemplo

      # Ejecutar todas las pruebas
      mix test
  """
  use ExUnit.Case
  alias DB.{TablaPistas, TablaUsuarios}

  # Inicializar servidores antes de cada prueba
  setup do
    {:ok, _pistas_pid} = TablaPistas.start_link()
    {:ok, _pistas_pid} = TablaUsuarios.start_link()
    :ok
  end

  @doc """
  Prueba la inicialización de la base de datos de pistas, asegurando que haya 20 pistas disponibles.

  ## Datos de prueba:
    - Salida esperada: La longitud de la lista de pistas debe ser 20.
  """
  test "inicializar pistas" do
    pistas = TablaPistas.seeAllPistas()
    assert length(pistas) == 20
  end

  @doc """
  Prueba reservar una pista correctamente para un usuario existente.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` con credenciales válidas y un número de pista `5`.
    - Salida esperada: El número de pista `5` debe ser reservado por `"usuario1"`.
  """
  test "reservar pista correctamente" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:ok, "usuario1"} = TablaPistas.reservar_pista("usuario1", 5)

    assert [%{numero: 5, reservada_por: "usuario1"}] ==
             TablaPistas.ver_reservas_usuario("usuario1")
  end

  @doc """
  Prueba reservar una pista no existente.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` y un número de pista inválido `25`.
    - Salida esperada: La operación debe devolver un error: `{:error, :pista_no_existente}`.
  """
  test "reservar pista no existente" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:error, :pista_no_existente} = TablaPistas.reservar_pista("usuario1", 25)
  end

  @doc """
  Prueba reservar una pista para un usuario no existente.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` (no existente) y un número de pista `5`.
    - Salida esperada: La operación debe devolver un error: `{:error, :usuario_no_existente}`.
  """
  test "reservar pista con usuario no existente" do
    assert {:error, :usuario_no_existente} = TablaPistas.reservar_pista("usuario1", 5)
  end

  @doc """
  Prueba liberar correctamente una pista reservada.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` con una pista reservada número `5`.
    - Salida esperada: La pista número `5` debe ser liberada y todas las pistas deben estar disponibles.
  """
  test "liberar pista correctamente" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:ok, "usuario1"} = TablaPistas.reservar_pista("usuario1", 5)
    assert {:ok, 5} = TablaPistas.liberar_pista("usuario1", 5)
    pistas = TablaPistas.seeAllPistas()
    assert Enum.all?(pistas, fn pista -> pista[:reservado_por] == nil end)
  end

  @doc """
  Prueba intentar liberar una pista por un usuario que no la reservó.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario2"` intentando liberar la pista número `5`, la cual fue reservada por `"usuario1"`.
    - Salida esperada: La operación debe devolver un error: `{:error, :no_autorizado}`.
  """
  test "liberar pista de otro usuario" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:ok, "usuario2"} = TablaUsuarios.addUser("usuario2", "pass2", "rol2")
    assert {:ok, "usuario1"} = TablaPistas.reservar_pista("usuario1", 5)
    assert {:error, :no_autorizado} = TablaPistas.liberar_pista("usuario2", 5)
  end

  @doc """
  Prueba intentar liberar una pista no existente.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` intentando liberar una pista número `21` (que no existe).
    - Salida esperada: La operación debe devolver un error: `{:error, :pista_no_existente}`.
  """
  test "liberar pista no existente" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:error, :pista_no_existente} = TablaPistas.liberar_pista("usuario1", 21)
  end

  @doc """
  Prueba intentar liberar una pista que no ha sido reservada.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` intentando liberar una pista número `5` (que no está reservada).
    - Salida esperada: La operación debe devolver un error: `{:error, :pista_no_reservada}`.
  """
  test "liberar pista no reservada" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:error, :pista_no_reservada} = TablaPistas.liberar_pista("usuario1", 5)
  end

  @doc """
  Prueba listar todas las reservas realizadas por un usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` con múltiples reservas de pistas (`5` y `10`).
    - Salida esperada: La lista de reservas del usuario debe incluir las pistas reservadas `5` y `10`.
  """
  test "listar reservas de un usuario" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:ok, "usuario1"} = TablaPistas.reservar_pista("usuario1", 5)
    assert {:ok, "usuario1"} = TablaPistas.reservar_pista("usuario1", 10)
    reservas = TablaPistas.ver_reservas_usuario("usuario1")

    assert reservas == [
             %{numero: 5, reservada_por: "usuario1"},
             %{numero: 10, reservada_por: "usuario1"}
           ]
  end
end
