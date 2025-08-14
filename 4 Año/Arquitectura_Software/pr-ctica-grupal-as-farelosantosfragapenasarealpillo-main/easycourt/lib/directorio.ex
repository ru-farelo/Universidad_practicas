defmodule Directorio do
  @moduledoc """
  Módulo `Directorio` que utiliza GenServer para gestionar la arquitectura de servidores y balancear las solicitudes entre ellos.
  """

  use GenServer

  @doc """
  Inicia la arquitectura creando tablas de pistas y usuarios, y varios servidores cliente y admin.
  Devuelve una tupla con los pids de los balanceadores, el primer servidor cliente, el primer servidor admin, y las tablas de pistas y usuarios.
  """
  def iniciarArquitectura() do
    {_, dbm} = DB.TablaPistas.start_link()
    {_, dbs} = DB.TablaUsuarios.start_link()
    {:ok, pid1} = GenServer.start(ServidorCliente, [])
    {:ok, pid2} = GenServer.start(ServidorCliente, [])
    {:ok, pid3} = GenServer.start(ServidorAdmin, [])
    {:ok, pid4} = GenServer.start(ServidorAdmin, [])

    {:ok, pid5} =
      GenServer.start(Directorio, %{serversAdmin: [pid3, pid4], serversUsers: [pid1, pid2]})

    {:ok, pid6} =
      GenServer.start(Directorio, %{serversAdmin: [pid3, pid4], serversUsers: [pid1, pid2]})

    {[pid5, pid6], pid1, pid3, dbm, dbs}
  end

  @doc """
  Inicia la arquitectura creando tablas de pistas y usuarios, y varios servidores cliente y admin.
  Devuelve una lista con los pids de los balanceadores.
  """
  def iniciarArquitecturaPids() do
    DB.TablaPistas.start_link()
    DB.TablaUsuarios.start_link()
    {:ok, pid1} = GenServer.start(ServidorCliente, [])
    {:ok, pid2} = GenServer.start(ServidorCliente, [])
    {:ok, pid3} = GenServer.start(ServidorAdmin, [])
    {:ok, pid4} = GenServer.start(ServidorAdmin, [])

    {:ok, pid5} =
      GenServer.start(Directorio, %{serversAdmin: [pid3, pid4], serversUsers: [pid1, pid2]})

    {:ok, pid6} =
      GenServer.start(Directorio, %{serversAdmin: [pid3, pid4], serversUsers: [pid1, pid2]})

    [pid5, pid6]
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc """
  Inicia el GenServer con el módulo `Directorio` y los argumentos dados.
  """
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :directorio)
  end

  @doc """
  Registra un nuevo usuario.
  """
  def signUp(pid, user, pass) do
    GenServer.call(pid, {:signUp, user, pass})
  end

  @doc """
  Verifica la contraseña de un usuario.
  """
  def checkPassword(pid, user, givenPass) do
    GenServer.call(pid, {:signIn, user, givenPass})
  end

  @doc """
  Actualiza la contraseña de un usuario.
  """
  def updatePassword(pid, user, pass) do
    GenServer.call(pid, {:updatePassword, user, pass})
  end

  @doc """
  Elimina un usuario.
  """
  def deleteUser(pid, user) do
    GenServer.call(pid, {:deleteUser, user})
  end

  @doc """
  Reserva una pista para un usuario.
  """
  def reservar_pista(pid, user, number) do
    GenServer.call(pid, {:reservar_pista, user, number})
  end

  @doc """
  Libera una pista reservada por un usuario.
  """
  def liberar_pista(pid, user, number) do
    GenServer.call(pid, {:liberar_pista, user, number})
  end

  @doc """
  Muestra las reservas de un usuario.
  """
  def ver_reservas_usuario(pid, user) do
    GenServer.call(pid, {:ver_reservas_usuario, user})
  end

  @doc """
  Muestra todas las pistas.
  """
  def seeAllPistas(pid) do
    GenServer.call(pid, {:seeAllPistas})
  end

  @doc """
  Obtiene el estado actual del directorio.
  """
  def getEstado(pid) do
    GenServer.call(pid, {:estado})
  end

  @impl true
  def handle_call({:estado}, _from, map) do
    {:reply, map, map}
  end

  # HANDLERS USUARIOS

  @impl true
  def handle_call({:signUp, user, password}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.singUp(primerServer(map.serversUsers), user, password), map}
    else
      {:reply, ServidorCliente.singUp(siguienteServer(map.serversUsers), user, password),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:signIn, user, password}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.checkPassword(primerServer(map.serversUsers), user, password), map}
    else
      {:reply, ServidorCliente.checkPassword(siguienteServer(map.serversUsers), user, password),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:updatePassword, user, password}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.updatePassword(primerServer(map.serversUsers), user, password), map}
    else
      {:reply, ServidorCliente.updatePassword(siguienteServer(map.serversUsers), user, password),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:deleteUser, user}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.deleteUser(primerServer(map.serversUsers), user), map}
    else
      {:reply, ServidorCliente.deleteUser(siguienteServer(map.serversUsers), user),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:reservar_pista, user, number}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.reservar_pista(primerServer(map.serversUsers), user, number), map}
    else
      {:reply, ServidorCliente.reservar_pista(siguienteServer(map.serversUsers), user, number),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:liberar_pista, user, number}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.liberar_pista(primerServer(map.serversUsers), user, number), map}
    else
      {:reply, ServidorCliente.liberar_pista(siguienteServer(map.serversUsers), user, number),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:ver_reservas_usuario, user}, _from, map) do
    if Process.alive?(primerServer(map.serversUsers)) do
      {:reply, ServidorCliente.ver_reservas_usuario(primerServer(map.serversUsers), user), map}
    else
      {:reply, ServidorCliente.ver_reservas_usuario(siguienteServer(map.serversUsers), user),
       %{map | serversUsers: eliminaCaidoCreaNuevoServerClientes(map.serversUsers)}}
    end
  end

  @impl true
  def handle_call({:seeAllPistas}, _from, map) do
    if Process.alive?(primerServer(map.serversAdmin)) do
      {:reply, ServidorAdmin.seeAllPistas(primerServer(map.serversAdmin)), map}
    else
      {:reply, ServidorAdmin.seeAllPistas(siguienteServer(map.serversAdmin)),
       %{map | serversAdmin: eliminaCaidoCreaNuevoServerAdmins(map.serversAdmin)}}
    end
  end

  defp primerServer([h | _]), do: h
  defp siguienteServer([_ | [h | _]]), do: h

  defp eliminaCaidoCreaNuevoServerClientes([_ | list]) do
    {:ok, pid} = GenServer.start(ServidorCliente, [])
    [list] ++ [pid]
  end


defp eliminaCaidoCreaNuevoServerAdmins([_ | list]) do
    {:ok, pid} = GenServer.start(ServidorAdmin, [])
    [list] ++ [pid]
  end

end
