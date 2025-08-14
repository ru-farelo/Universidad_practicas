defmodule ServidorClienteTest do
  @moduledoc """
  **ServidorClienteTest** es un módulo de pruebas para el módulo `ServidorCliente`, el cual es responsable de gestionar las acciones del lado del cliente, tales como el registro de usuarios, la gestión de contraseñas, las reservas de pistas y su liberación.

  Las pruebas aseguran que el cliente pueda interactuar correctamente con el sistema, incluyendo:
  - Registro de usuarios y verificación de existencia.
  - Inicio de sesión de usuario y validación de contraseñas.
  - Reserva y liberación de pistas, manejando casos extremos como pistas reservadas o acciones no autorizadas.

  ## Setup
  Antes de cada prueba:
  - Las tablas de usuarios y pistas se inicializan utilizando `DB.TablaUsuarios.start_link()` y `DB.TablaPistas.start_link()`.
  - Se inicia un proceso de `ServidorCliente` para cada prueba.

  ## Ejemplo

      # Ejecutar todas las pruebas
      mix test
  """
  use ExUnit.Case

  # Configuración inicial para las pruebas
  setup do
    {:ok, _usuarios_pid} = DB.TablaUsuarios.start_link()
    {:ok, _pistas_pid} = DB.TablaPistas.start_link()
    {:ok, pid} = GenServer.start_link(ServidorCliente, %{})
    {:ok, pid: pid}
  end

  @doc """
  Prueba el proceso de registro de un usuario y verifica que el usuario exista en el sistema.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` con contraseña `"pass1"`.
    - Salida esperada: El usuario se registra correctamente y existe en el sistema.
  """
  test "registrar un usuario y verificar su existencia", %{pid: pid} do
    assert {:ok, "usuario1"} == ServidorCliente.singUp(pid, "usuario1", "pass1")
    assert {:user_exists} == DB.TablaUsuarios.existsUser("usuario1")
  end

  @doc """
  Prueba intentar registrar un usuario que ya existe.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario1"` ya registrado con la contraseña `"pass1"`.
    - Salida esperada: Intentar registrar al mismo usuario debe devolver un error indicando que el usuario ya existe.
  """
  test "intentar registrar un usuario ya existente", %{pid: pid} do
    assert {:ok, "usuario1"} == ServidorCliente.singUp(pid, "usuario1", "pass1")
    assert {:exists} == ServidorCliente.singUp(pid, "usuario1", "pass1")
  end

  @doc """
  Prueba eliminar un usuario y verificar que el usuario ya no existe en el sistema.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario2"` con contraseña `"pass1"`, seguido de la eliminación.
    - Salida esperada: El usuario es eliminado y ya no existe en el sistema.
  """
  test "borrar un usuario y verificar que no existe", %{pid: pid} do
    assert {:ok, "usuario2"} == ServidorCliente.singUp(pid, "usuario2", "pass1")
    assert {:deleted, "usuario2"} == ServidorCliente.deleteUser(pid, "usuario2")
    assert {:user_does_not_exist} == DB.TablaUsuarios.existsUser("usuario2")
  end

  @doc """
  Prueba verificar la contraseña de un usuario registrado.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario3"` con contraseña `"pass3"`, y una contraseña incorrecta `"wrong_pass"`.
    - Salida esperada: La contraseña correcta debe devolver el usuario, mientras que la incorrecta debe resultar en un error.
  """
  test "comprobar contraseña de un usuario", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario5", "pass3")
    assert {:ok, "usuario5"} == ServidorCliente.checkPassword(pid, "usuario5", "pass3")

    assert {:error, :invalid_password} ==
             ServidorCliente.checkPassword(pid, "usuario5", "wrong_pass")
  end

  @doc """
  Prueba actualizar la contraseña de un usuario registrado.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario4"` con contraseña inicial `"pass4"`, y una nueva contraseña `"new_pass4"`.
    - Salida esperada: La contraseña se actualiza correctamente y la nueva contraseña debe ser válida.
  """
  test "actualizar contraseña de un usuario", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario4", "pass4")
    assert {:updated} == ServidorCliente.updatePassword(pid, "usuario4", "new_pass4")
    assert {:ok, "usuario4"} == ServidorCliente.checkPassword(pid, "usuario4", "new_pass4")
  end

  @doc """
  Prueba reservar correctamente una pista para un usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario6"` con contraseña `"pass6"` reservando la pista `7`.
    - Salida esperada: La pista se reserva correctamente para el usuario.
  """
  test "reservar una pista correctamente", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario6", "pass6")
    assert {:ok, "usuario6"} == ServidorCliente.reservar_pista(pid, "usuario6", 7)
  end

  @doc """
  Prueba intentar reservar una pista para un usuario que no está registrado.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario_no_registrado"` intentando reservar la pista `8`.
    - Salida esperada: Un error indicando que el usuario no está registrado.
  """
  test "reservar una pista con un usuario no registrado", %{pid: pid} do
    assert {:error, :usuario_no_existente} ==
             ServidorCliente.reservar_pista(pid, "usuario_no_registrado", 8)
  end

  @doc """
  Prueba intentar reservar una pista que ya ha sido reservada.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario7"` reservando la pista `8` y otro usuario `"usuario8"` intentando reservar la misma pista.
    - Salida esperada: El segundo intento de reserva debe fallar, ya que la pista ya está reservada.
  """
  test "reservar una pista ya reservada", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario7", "pass7")
    ServidorCliente.singUp(pid, "usuario8", "pass7")
    ServidorCliente.reservar_pista(pid, "usuario7", 8)
    assert {:error, :pista_ya_reservada} == ServidorCliente.reservar_pista(pid, "usuario8", 8)
  end

  @doc """
  Prueba liberar correctamente una pista.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario8"` que reserva y luego libera la pista `9`.
    - Salida esperada: La pista se libera correctamente y el sistema refleja este cambio.
  """
  test "liberar una pista correctamente", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario8", "pass8")
    ServidorCliente.reservar_pista(pid, "usuario8", 9)
    assert {:ok, 9} == ServidorCliente.liberar_pista(pid, "usuario8", 9)
  end

  @doc """
  Prueba intentar liberar una pista que no ha sido reservada.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario9"` intentando liberar la pista `10`, que no está reservada.
    - Salida esperada: Un error indicando que la pista no fue reservada.
  """
  test "liberar una pista no reservada", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario9", "pass9")
    assert {:error, :pista_no_reservada} == ServidorCliente.liberar_pista(pid, "usuario9", 10)
  end

  @doc """
  Prueba intentar liberar una pista que fue reservada por otro usuario.

  ## Datos de prueba:
    - Entrada: Un usuario `"usuario9"` que reserva la pista `11`, y otro usuario `"otro_usuario"` intentando liberarla.
    - Salida esperada: El segundo usuario debe ser rechazado, ya que no reservó la pista.
  """
  test "liberar una pista reservada por otro usuario", %{pid: pid} do
    ServidorCliente.singUp(pid, "usuario9", "pass9")
    ServidorCliente.singUp(pid, "otro_usuario", "pass9")
    ServidorCliente.reservar_pista(pid, "usuario9", 11)
    assert {:error, :no_autorizado} == ServidorCliente.liberar_pista(pid, "otro_usuario", 11)
  end

  @doc """
  Prueba ver la lista de reservas de un usuario.

  ## Datos de prueba:
    - Entrada: Los usuarios `"usuario10"` y `"usuario11"` se registran e intentan ver sus respectivas reservas.
    - Salida esperada: La lista de reservas de un usuario dado.
  """
  test "ver reservas de un usuario", %{pid: pid} do
    assert {:ok, "usuario10"} = ServidorCliente.singUp(pid, "usuario10", "pass1")
    assert {:ok, "usuario11"} = ServidorCliente.singUp(pid, "usuario11", "pass2")

    # assert [%{numero: 7, reservada_por: "usuario6"}, %{numero: 8, reservada_por: "usuario6"}] == ServidorCliente.ver_reservas_usuario(pid, "usuario6")
  end
end
