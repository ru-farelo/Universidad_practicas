defmodule UserDataBaseTest do
  @moduledoc """
  **UserDataBaseTest** es un módulo de pruebas para la gestión de usuarios en la base de datos.

  El módulo se encarga de probar las funciones relacionadas con el manejo de usuarios en la base de datos. Las pruebas incluyen:
  - Añadir un usuario y verificar su existencia.
  - Comprobar contraseñas de usuarios.
  - Actualizar contraseñas de usuarios.
  - Borrar usuarios y verificar su inexistencia.
  - Ver la lista de usuarios.

  ## Setup
  Antes de cada prueba, se inicializa un servidor para la tabla de usuarios mediante la función `TablaUsuarios.start_link/0`, asegurando que las pruebas sean independientes y no afecten a los datos previos.

  ## Ejemplo

      # Ejecuta todas las pruebas
      mix test
  """
  use ExUnit.Case
  alias DB.TablaUsuarios

  # Inicializar los servidores antes de cada prueba
  setup do
    {:ok, _usuarios_pid} = TablaUsuarios.start_link()
    :ok
  end

  @doc """
  Prueba la adición de un usuario y la comprobación de su existencia.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"`, con contraseña `"pass1"` y rol `"rol1"`.
    - Resultado esperado: El usuario se agrega correctamente y existe en la base de datos.
  """
  test "añadir y comprobar usuario" do
    assert {:ok, "usuario1"} = TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    assert {:user_exists} = TablaUsuarios.existsUser("usuario1")
  end

  @doc """
  Prueba la verificación de la contraseña de un usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario2"` con contraseña `"pass2"`.
    - Resultado esperado: La contraseña se valida correctamente, y las contraseñas incorrectas generan un error.
  """
  test "comprobar contraseña" do
    assert {:ok, "usuario2"} = TablaUsuarios.addUser("usuario2", "pass2", "rol2")
    assert {:ok, "usuario2"} = TablaUsuarios.checkPassword("usuario2", "pass2")
    assert {:error, :invalid_password} = TablaUsuarios.checkPassword("usuario2", "wrong_pass")
    assert {:error, :user_not_found} = TablaUsuarios.checkPassword("nonexistent_user", "pass")
  end

  @doc """
  Prueba la actualización de la contraseña de un usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario3"` con contraseña inicial `"pass3"`.
    - Resultado esperado: La contraseña del usuario se actualiza correctamente.
  """
  test "actualizar contraseña" do
    assert {:ok, "usuario3"} = TablaUsuarios.addUser("usuario3", "pass3", "rol1")
    assert {:updated} = TablaUsuarios.updatePassword("usuario3", "pass4")
  end

  @doc """
  Prueba el borrado de un usuario y la verificación de que ya no existe.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario3"`.
    - Resultado esperado: El usuario se elimina correctamente y no existe más en la base de datos.
  """
  test "borrar usuario y verificar que no existe" do
    assert {:deleted, "usuario3"} = TablaUsuarios.deleteUser("usuario3")
    assert {:user_does_not_exist} = TablaUsuarios.existsUser("usuario3")
  end

  @doc """
  Prueba la visualización de todos los usuarios en la base de datos.

  ## Datos de prueba:
    - Entrada: Se agregan varios usuarios.
    - Resultado esperado: Se devuelve la lista completa de usuarios, incluyendo su nombre y rol.
  """
  test "ver usuarios" do
    TablaUsuarios.addUser("usuario1", "pass1", "rol1")
    TablaUsuarios.addUser("usuario2", "pass2", "rol2")

    expected_users = [
      {"admin1", "rolAdmin"},
      {"admin2", "rolAdmin"},
      {"admin3", "rolAdmin"},
      {"usuario1", "rol1"},
      {"usuario2", "rol2"}
    ]

    assert Enum.sort(expected_users) == Enum.sort(TablaUsuarios.seeAllUsers())
  end
end
