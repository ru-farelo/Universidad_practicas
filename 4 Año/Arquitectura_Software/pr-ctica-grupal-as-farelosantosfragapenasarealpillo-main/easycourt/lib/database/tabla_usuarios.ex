defmodule DB.TablaUsuarios do
  @moduledoc """
  Módulo que gestiona las operaciones sobre los usuarios dentro de una base de datos,
  utilizando un `GenServer`. Este módulo permite agregar, eliminar, actualizar,
  y verificar usuarios y contraseñas, así como obtener una lista de usuarios.

  ## Funcionalidad

  - **Añadir usuario**: Permite agregar un usuario con su contraseña y rol.
  - **Verificar contraseña**: Compara la contraseña proporcionada con la almacenada para un usuario.
  - **Comprobar existencia de usuario**: Verifica si un usuario existe en la base de datos.
  - **Eliminar usuario**: Elimina un usuario de la base de datos.
  - **Actualizar contraseña**: Cambia la contraseña de un usuario existente.
  - **Ver todos los usuarios**: Devuelve la lista de usuarios (sin las contraseñas).

  El sistema asegura que no se puede agregar un usuario que ya exista, y que las contraseñas
  se verifican de forma correcta.
  """

  use GenServer

  # Iniciar el GenServer con el nombre UserDB
  @doc """
  Inicia el GenServer `UserDB`, donde se gestionan los usuarios de la base de datos.

  ## Ejemplo

      iex> DB.TablaUsuarios.start_link()
      {:ok, pid}
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: UserDB)
  end

  # Añadir un usuario
  @doc """
  Añade un nuevo usuario con la contraseña y el rol proporcionados, si el usuario no existe.

  ## Parámetros
    - `user`: nombre del usuario.
    - `pass`: contraseña del usuario.
    - `role`: rol del usuario.

  ## Ejemplo

      iex> DB.TablaUsuarios.addUser("Juan", "password123", "rolUsuario")
      {:ok, "Juan"}
  """
  def addUser(user, pass, role) do
    GenServer.call(UserDB, {:add_user, user, pass, role})
  end

  # Comprobar la contraseña de un usuario
  @doc """
  Compara la contraseña proporcionada con la almacenada para el usuario indicado.

  ## Parámetros
    - `user`: nombre del usuario.
    - `pass`: contraseña proporcionada.

  ## Ejemplo

      iex> DB.TablaUsuarios.checkPassword("Juan", "password123")
      {:ok, "Juan"}
  """
  def checkPassword(user, pass) do
    GenServer.call(UserDB, {:check_pass, user, pass})
  end

  # Comprobar si un usuario existe en la base de datos
  @doc """
  Verifica si un usuario existe en la base de datos.

  ## Parámetros
    - `user`: nombre del usuario.

  ## Ejemplo

      iex> DB.TablaUsuarios.existsUser("Juan")
      {:user_exists}
  """
  def existsUser(user) do
    GenServer.call(UserDB, {:check_user, user})
  end

  # Eliminar un usuario
  @doc """
  Elimina un usuario de la base de datos.

  ## Parámetros
    - `user`: nombre del usuario a eliminar.

  ## Ejemplo

      iex> DB.TablaUsuarios.deleteUser("Juan")
      {:deleted, "Juan"}
  """
  def deleteUser(user) do
    GenServer.call(UserDB, {:del_user, user})
  end

  # Actualizar la contraseña de un usuario
  @doc """
  Actualiza la contraseña de un usuario existente.

  ## Parámetros
    - `user`: nombre del usuario.
    - `newPassword`: nueva contraseña.

  ## Ejemplo

      iex> DB.TablaUsuarios.updatePassword("Juan", "newPassword123")
      {:updated}
  """
  def updatePassword(user, newPassword) do
    GenServer.call(UserDB, {:update_password, user, newPassword})
  end

  # Ver todos los usuarios
  @doc """
  Devuelve una lista de todos los usuarios, excluyendo las contraseñas.

  ## Ejemplo

      iex> DB.TablaUsuarios.seeAllUsers()
      [{"Juan", "rolUsuario"}, ...]
  """
  def seeAllUsers do
    GenServer.call(UserDB, :see_all_users)
  end

  # Server callbacks

  @impl GenServer
  def init(_) do
    usuarios_iniciales = crearAdmins([])

    {:ok, %{usuarios: usuarios_iniciales}}
  end

  @impl GenServer
  def handle_call({:add_user, user, pass, role}, _, %{usuarios: usuarios} = state) do
    if Db.find_element(user, usuarios) != {:not_found} do
      {:reply, {:exists}, state}
    else
      new_usuarios = Db.add_element(user, pass, role, usuarios)
      {:reply, {:ok, user}, %{state | usuarios: new_usuarios}}
    end
  end

  @impl GenServer
  def handle_call({:update_password, user, newPassword}, _, list_state) do
    {:reply, {:updated}, Db.update(list_state, user, newPassword)}
  end

  @impl GenServer
  def handle_call(:see_all_users, _, %{usuarios: usuarios} = state) do
    usuarios_sin_contraseña = Enum.map(usuarios, fn {user, _, role} -> {user, role} end)
    {:reply, usuarios_sin_contraseña, state}
  end

  @impl GenServer
  def handle_call({:check_pass, user, pass}, _, list_state) do
    reply = check_pass(Db.find_element(user, list_state), pass)
    {:reply, reply, list_state}
  end

  @impl GenServer
  def handle_call({:check_user, user}, _, %{usuarios: usuarios} = state) do
    {:reply, check_user(Db.find_element(user, usuarios)), state}
  end

  @impl GenServer
  def handle_call({:del_user, user_toDel}, _, list_state) do
    if Db.find_element(user_toDel, list_state) != {:not_found} do
      {:reply, {:deleted, user_toDel}, Db.del_element(user_toDel, list_state)}
    else
      {:reply, {:not_found, user_toDel}, list_state}
    end
  end

  # Funciones auxiliares

  defp check_pass({key, stored_pass, _role}, provided_pass) when stored_pass == provided_pass,
    do: {:ok, key}

  defp check_pass({_, _stored_pass, _role}, _), do: {:error, :invalid_password}
  defp check_pass(:not_found, _), do: {:error, :user_not_found}

  defp check_user({:not_found}), do: {:user_does_not_exist}
  defp check_user(_), do: {:user_exists}

  defp crearAdmins(usuarios) do
    encrypted_pass = fn password -> Encriptado.encriptar(password) end

    usuarios1 = Db.add_element("admin1", encrypted_pass.("admin123"), "rolAdmin", usuarios)
    usuarios2 = Db.add_element("admin2", encrypted_pass.("admin123"), "rolAdmin", usuarios1)
    usuarios3 = Db.add_element("admin3", encrypted_pass.("admin123"), "rolAdmin", usuarios2)

    usuarios3
  end
end
