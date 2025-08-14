defmodule ServidorAdmin do
  @moduledoc """
  **ServidorAdmin** es un GenServer encargado de gestionar tareas específicas del administrador, como el registro de usuarios,
  inicio de sesión, eliminación de usuarios, actualización de contraseñas y visualización de todas las canchas (pistas) reservadas.

  Este módulo interactúa con las tablas de base de datos (`DB.TablaUsuarios` y `DB.TablaPistas`) para
  manejar operaciones relacionadas con los usuarios y las canchas.

  ## API Pública

  - `start_link/1`: Inicia una nueva instancia de GenServer `ServidorAdmin`.
  - `singUp/3`: Registra un nuevo usuario con nombre de usuario, contraseña y rol de administrador.
  - `singIn/3`: Verifica si el nombre de usuario y la contraseña proporcionados son correctos.
  - `deleteUser/2`: Elimina un usuario y libera las canchas que haya reservado.
  - `checkPassword/3`: Verifica si la contraseña proporcionada coincide con la registrada del usuario.
  - `updatePassword/3`: Actualiza la contraseña para el usuario especificado.
  - `seeAllPistas/1`: Recupera y devuelve una lista de todas las reservas de canchas.

  ## Ejemplo

      # Iniciando el servidor
      {:ok, pid} = ServidorAdmin.start_link(%{})

      # Registrando un usuario
      ServidorAdmin.singUp(pid, "usuario", "contraseña")

      # Verificando las credenciales del usuario
      ServidorAdmin.singIn(pid, "usuario", "contraseña")

      # Eliminando un usuario
      ServidorAdmin.deleteUser(pid, "usuario")

      # Actualizando la contraseña del usuario
      ServidorAdmin.updatePassword(pid, "usuario", "nueva_contraseña")

      # Visualizando todas las reservas de canchas
      ServidorAdmin.seeAllPistas(pid)
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
  Inicia el GenServer `ServidorAdmin` con el estado inicial proporcionado.

  ## Argumentos:
    - `initial_state`: Estado inicial opcional para el GenServer.

  ## Retorna:
    - `{:ok, pid}`: Una tupla que contiene el PID del servidor iniciado.
  """
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  @doc """
  Registra un nuevo usuario con el nombre de usuario y la contraseña proporcionados como administrador.

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
  Elimina un usuario del sistema y libera las canchas reservadas asociadas con ese usuario.

  ## Argumentos:
    - `pid`: El PID del GenServer.
    - `user`: El nombre de usuario del usuario a eliminar.

  ## Retorna:
    - El resultado de eliminar el usuario de la base de datos `DB.TablaUsuarios`.
  """
  def deleteUser(pid, user) do
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
  Recupera y devuelve una lista de todas las reservas de canchas (pistas).

  ## Argumentos:
    - `pid`: El PID del GenServer.

  ## Retorna:
    - Una lista de todas las reservas de canchas desde la base de datos `DB.TablaPistas`.
  """
  def seeAllPistas(pid) do
    GenServer.call(pid, {:see_all_pistas})
  end

  ## Manejadores (Handlers)

  def handle_call({:signUp, user, pass}, _from, _state) do
    {:reply, DB.TablaUsuarios.addUser(user, pass, "rolAdmin"), []}
  end

  def handle_call({:delete_user, user}, _from, _state) do
    # Obtener las reservas del usuario
    reservas_usuario = DB.TablaPistas.ver_reservas_usuario(user)

    # Liberar cada cancha reservada
    Enum.each(reservas_usuario, fn %{numero: numero} ->
      DB.TablaPistas.liberar_pista(user, numero)
    end)

    {:reply, DB.TablaUsuarios.deleteUser(user), []}
  end

  def handle_call({:check_pass, user, pass}, _from, _state) do
    {:reply, DB.TablaUsuarios.checkPassword(user, pass), []}
  end

  def handle_call({:update_password, user, newPassword}, _from, _state) do
    {:reply, DB.TablaUsuarios.updatePassword(user, newPassword), []}
  end

  def handle_call({:see_all_pistas}, _from, state) do
    {:reply, DB.TablaPistas.seeAllPistas(), state}
  end
end
