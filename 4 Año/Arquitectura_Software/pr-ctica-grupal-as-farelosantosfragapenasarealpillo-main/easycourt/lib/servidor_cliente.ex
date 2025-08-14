defmodule ServidorCliente do
  @moduledoc """
  **ServidorCliente** es un GenServer encargado de manejar operaciones específicas del cliente relacionadas con la gestión de usuarios
  (registro, inicio de sesión, gestión de contraseñas) y reservas de canchas (pistas). Interactúa con la base de datos (`DB.TablaUsuarios`
  y `DB.TablaPistas`) para realizar acciones como el registro de usuarios, la verificación de credenciales, la reserva o liberación de canchas,
  y la eliminación de usuarios.

  ## API Pública

  - `start_link/1`: Inicia una nueva instancia del GenServer `ServidorCliente`.
  - `singUp/3`: Registra un nuevo usuario con un nombre de usuario y contraseña como cliente.
  - `singIn/3`: Verifica si el nombre de usuario y la contraseña proporcionados coinciden.
  - `deleteUser/2`: Elimina un usuario y libera las canchas que haya reservado.
  - `checkPassword/3`: Verifica si la contraseña proporcionada coincide con la contraseña almacenada para el usuario.
  - `updatePassword/3`: Actualiza la contraseña de un usuario especificado.
  - `reservar_pista/3`: Reserva una cancha para un usuario.
  - `liberar_pista/3`: Libera una cancha reservada.
  - `ver_reservas_usuario/2`: Recupera todas las reservas realizadas por un usuario específico.

  ## Ejemplo

      # Iniciando el servidor
      {:ok, pid} = ServidorCliente.start_link(%{})

      # Registrando un usuario
      ServidorCliente.singUp(pid, "usuario", "contraseña")

      # Verificando las credenciales del usuario
      ServidorCliente.singIn(pid, "usuario", "contraseña")

      # Eliminando un usuario
      ServidorCliente.deleteUser(pid, "usuario")

      # Actualizando la contraseña del usuario
      ServidorCliente.updatePassword(pid, "usuario", "nueva_contraseña")

      # Reservando una cancha
      ServidorCliente.reservar_pista(pid, "usuario", 1)

      # Liberando una cancha
      ServidorCliente.liberar_pista(pid, "usuario", 1)

      # Visualizando las reservas de un usuario
      ServidorCliente.ver_reservas_usuario(pid, "usuario")
  """
  use GenServer

  @doc """
  Inicializa el servidor con un estado inicial opcional.

  ## Argumentos:
    - `initial_state`: El estado inicial del servidor, que por defecto es un mapa vacío.

  ## Retorna:
    - `{:ok, initial_state}`: El estado inicial del servidor.
  """
  def init(initial_state) do
    {:ok, initial_state || %{}}
  end

  @doc """
  Inicia el GenServer `ServidorCliente` con el estado inicial proporcionado.

  ## Argumentos:
    - `initial_state`: Estado inicial opcional para el GenServer.

  ## Retorna:
    - `{:ok, pid}`: Una tupla que contiene el PID del servidor iniciado.
  """
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  @doc """
  Registra un nuevo usuario con el nombre de usuario y la contraseña proporcionados como cliente.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario del nuevo usuario.
    - `pass`: La contraseña del nuevo usuario.

  ## Retorna:
    - El resultado de agregar el usuario a la base de datos `DB.TablaUsuarios`.
  """
  def singUp(pid, user, pass) do
    GenServer.call(pid, {:signUp, user, pass})
  end

  @doc """
  Verifica si el nombre de usuario y la contraseña proporcionados coinciden con las credenciales en la base de datos.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario a verificar.
    - `pass`: La contraseña a verificar.

  ## Retorna:
    - El resultado de verificar la contraseña contra `DB.TablaUsuarios`.
  """
  def singIn(pid, user, pass) do
    GenServer.call(pid, {:check_pass, user, pass})
  end

  @doc """
  Elimina un usuario del sistema y libera las canchas que haya reservado.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario del usuario a eliminar.

  ## Retorna:
    - El resultado de eliminar el usuario de la base de datos `DB.TablaUsuarios`.
  """
  def deleteUser(pid, user) do
    # Obtener las reservas del usuario
    reservas_usuario = GenServer.call(pid, {:ver_reservas_usuario, user})

    # Liberar cada cancha reservada
    Enum.each(reservas_usuario, fn %{numero: numero} ->
      GenServer.call(pid, {:liberar_pista, user, numero})
    end)

    # Finalmente, eliminar el usuario
    GenServer.call(pid, {:delete_user, user})
  end

  @doc """
  Verifica si la contraseña proporcionada coincide con la contraseña del usuario en el sistema.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario del usuario a verificar.
    - `givenPass`: La contraseña a verificar.

  ## Retorna:
    - El resultado de verificar la contraseña contra `DB.TablaUsuarios`.
  """
  def checkPassword(pid, user, givenPass) do
    GenServer.call(pid, {:check_pass, user, givenPass})
  end

  @doc """
  Actualiza la contraseña para el usuario especificado.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario cuyo password se va a actualizar.
    - `newPassword`: La nueva contraseña a establecer para el usuario.

  ## Retorna:
    - El resultado de actualizar la contraseña en la base de datos `DB.TablaUsuarios`.
  """
  def updatePassword(pid, user, newPassword) do
    GenServer.call(pid, {:update_password, user, newPassword})
  end

  @doc """
  Reserva una cancha para el usuario especificado.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario que reserva la cancha.
    - `number`: El número de la cancha a reservar.

  ## Retorna:
    - El resultado de reservar la cancha en `DB.TablaPistas`.
  """
  def reservar_pista(pid, user, number) do
    GenServer.call(pid, {:reservar_pista, user, number})
  end

  @doc """
  Libera una cancha reservada para el usuario especificado.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario que libera la cancha.
    - `number`: El número de la cancha a liberar.

  ## Retorna:
    - El resultado de liberar la cancha en `DB.TablaPistas`.
  """
  def liberar_pista(pid, user, number) do
    GenServer.call(pid, {:liberar_pista, user, number})
  end

  @doc """
  Recupera todas las reservas de canchas realizadas por un usuario específico.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario cuyas reservas se están recuperando.

  ## Retorna:
    - Una lista de reservas para el usuario especificado desde `DB.TablaPistas`.
  """
  def ver_reservas_usuario(pid, user) do
    GenServer.call(pid, {:ver_reservas_usuario, user})
  end

  ## Manejadores (Handlers)

  def handle_call({:signUp, user, pass}, _from, _state) do
    {:reply, DB.TablaUsuarios.addUser(user, pass, "rolCliente"), []}
  end

  def handle_call({:delete_user, user}, _from, _state) do
    {:reply, DB.TablaUsuarios.deleteUser(user), []}
  end

  def handle_call({:check_pass, user, pass}, _from, _state) do
    {:reply, DB.TablaUsuarios.checkPassword(user, pass), []}
  end

  def handle_call({:update_password, user, newPassword}, _from, _state) do
    {:reply, DB.TablaUsuarios.updatePassword(user, newPassword), []}
  end

  def handle_call({:reservar_pista, user, number}, _from, _state) do
    {:reply, DB.TablaPistas.reservar_pista(user, number), []}
  end

  def handle_call({:liberar_pista, user, number}, _from, _state) do
    {:reply, DB.TablaPistas.liberar_pista(user, number), []}
  end

  def handle_call({:ver_reservas_usuario, user}, _from, _state) do
    {:reply, DB.TablaPistas.ver_reservas_usuario(user), []}
  end
end
