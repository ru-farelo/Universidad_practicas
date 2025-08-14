defmodule ServidorAdminTest do
  @moduledoc """
  **ServidorAdminTest** es un módulo de prueba que contiene una serie de casos de prueba para verificar
  la funcionalidad de los módulos `ServidorAdmin` y `ServidorCliente`, los cuales interactúan
  con los datos de usuarios y reservas de pistas.

  Las pruebas cubren:
  - Registro de usuarios, eliminación y gestión de contraseñas.
  - Verificación de la existencia de usuarios y manejo de errores relacionados con acciones de usuarios.
  - Gestión de pistas, incluyendo reservas y consulta de todas las pistas.

  ## Configuración
  Se realiza la siguiente configuración antes de cada prueba:
  - `DB.TablaUsuarios.start_link()` inicializa la base de datos de usuarios.
  - `DB.TablaPistas.start_link()` inicializa la base de datos de pistas.
  - Se inicia un proceso `ServidorAdmin` para manejar las acciones administrativas.
  - Se inicia un proceso `ServidorCliente` para manejar las acciones del cliente.

  ## Ejemplo

      # Ejecutar todas las pruebas
      mix test
  """
  use ExUnit.Case

  # Configuración inicial para las pruebas
  setup do
    {:ok, _usuarios_pid} = DB.TablaUsuarios.start_link()
    {:ok, _pistas_pid} = DB.TablaPistas.start_link()

    {:ok, admin_pid} = GenServer.start_link(ServidorAdmin, %{})
    {:ok, cliente_pid} = GenServer.start_link(ServidorCliente, %{})

    # Devolver un mapa con los PIDs de los procesos
    {:ok, admin_pid: admin_pid, cliente_pid: cliente_pid}
  end

  @doc """
  Prueba el proceso de registro de un usuario y verifica si el usuario existe.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` con contraseña `"pass1"`.
    - Salida esperada: El usuario debe ser registrado correctamente y debe existir en el sistema.
  """
  test "registrar un usuario y verificar su existencia", %{admin_pid: admin_pid} do
    assert {:ok, "usuario1"} == ServidorAdmin.singUp(admin_pid, "usuario1", "pass1")
    assert {:user_exists} == DB.TablaUsuarios.existsUser("usuario1")
  end

  @doc """
  Prueba eliminar un usuario y verificar que el usuario ya no exista.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario2"` con contraseña `"pass2"`, que será eliminado después del registro.
    - Salida esperada: El usuario `"usuario2"` debe ser eliminado y ya no debe existir en el sistema.
  """
  test "borrar un usuario y verificar que no existe", %{
    cliente_pid: cliente_pid,
    admin_pid: admin_pid
  } do
    ServidorAdmin.singUp(admin_pid, "usuario2", "pass2")
    assert {:ok, "usuario2"} == ServidorCliente.reservar_pista(cliente_pid, "usuario2", 12)
    assert {:deleted, "usuario2"} == ServidorAdmin.deleteUser(admin_pid, "usuario2")
    assert {:user_does_not_exist} == DB.TablaUsuarios.existsUser("usuario2")
  end

  @doc """
  Prueba comprobar la contraseña de un usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario3"` con contraseña `"pass3"`, y una contraseña incorrecta `"wrong_pass"`.
    - Salida esperada: La contraseña correcta debe devolver al usuario, mientras que la incorrecta debe generar un error.
  """
  test "comprobar contraseña de un usuario", %{admin_pid: admin_pid} do
    ServidorAdmin.singUp(admin_pid, "usuario3", "pass3")
    assert {:ok, "usuario3"} == ServidorAdmin.checkPassword(admin_pid, "usuario3", "pass3")

    assert {:error, :invalid_password} ==
             ServidorAdmin.checkPassword(admin_pid, "usuario3", "wrong_pass")
  end

  @doc """
  Prueba actualizar la contraseña de un usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario4"` con contraseña inicial `"pass4"`, y una nueva contraseña `"new_pass4"`.
    - Salida esperada: La contraseña debe ser actualizada y la nueva contraseña debe ser válida.
  """
  test "actualizar contraseña de un usuario", %{admin_pid: admin_pid} do
    assert {:ok, "usuario4"} == ServidorAdmin.singUp(admin_pid, "usuario4", "pass4")
    assert {:updated} == ServidorAdmin.updatePassword(admin_pid, "usuario4", "new_pass4")
    assert {:ok, "usuario4"} == ServidorAdmin.checkPassword(admin_pid, "usuario4", "new_pass4")
  end

  @doc """
  Prueba consultar y verificar todas las pistas en el sistema, incluyendo verificar cuáles están reservadas.

  ## Datos de prueba:
    - Entrada: Dos usuarios `"usuario1"` y `"usuario2"` reservando las pistas `12` y `13`, respectivamente.
    - Salida esperada: La lista de todas las pistas debe incluir las reservas de los dos usuarios.
  """
  test "ver todas las pistas", %{cliente_pid: cliente_pid, admin_pid: admin_pid} do
    assert {:ok, "usuario1"} == ServidorCliente.singUp(cliente_pid, "usuario1", "pass1")
    assert {:ok, "usuario2"} == ServidorCliente.singUp(cliente_pid, "usuario2", "pass2")
    assert {:ok, "usuario1"} == ServidorCliente.reservar_pista(cliente_pid, "usuario1", 12)
    assert {:ok, "usuario2"} == ServidorCliente.reservar_pista(cliente_pid, "usuario2", 13)

    all_pistas = ServidorAdmin.seeAllPistas(admin_pid)

    assert [
             %{numero: 1, reservada_por: nil},
             %{numero: 2, reservada_por: nil},
             %{numero: 3, reservada_por: nil},
             %{numero: 4, reservada_por: nil},
             %{numero: 5, reservada_por: nil},
             %{numero: 6, reservada_por: nil},
             %{numero: 7, reservada_por: nil},
             %{numero: 8, reservada_por: nil},
             %{numero: 9, reservada_por: nil},
             %{numero: 10, reservada_por: nil},
             %{numero: 11, reservada_por: nil},
             %{numero: 12, reservada_por: "usuario1"},
             %{numero: 13, reservada_por: "usuario2"},
             %{numero: 14, reservada_por: nil},
             %{numero: 15, reservada_por: nil},
             %{numero: 16, reservada_por: nil},
             %{numero: 17, reservada_por: nil},
             %{numero: 18, reservada_por: nil},
             %{numero: 19, reservada_por: nil},
             %{numero: 20, reservada_por: nil}
           ] == all_pistas
  end
end
