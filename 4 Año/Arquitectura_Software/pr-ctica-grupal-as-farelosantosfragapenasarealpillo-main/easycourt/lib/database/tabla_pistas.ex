defmodule DB.TablaPistas do
  @moduledoc """
  Módulo que maneja la reserva y liberación de pistas dentro de una base de datos de tenis,
  utilizando un `GenServer`. La implementación simula un sistema de gestión de pistas,
  donde los usuarios pueden reservar, liberar y consultar las pistas disponibles.

  ## Funcionalidad

  - **Iniciar el GenServer**: Se inicia con `start_link/0`, con el nombre de servidor `:CourtDB`.
  - **Reservar una pista**: Los usuarios pueden reservar una pista si está disponible.
  - **Liberar una pista**: Los usuarios pueden liberar una pista reservada previamente.
  - **Ver las reservas de un usuario**: Los usuarios pueden consultar las pistas que han reservado.
  - **Ver todas las pistas**: Consulta el estado de todas las pistas, mostrando quién las ha reservado.

  El sistema asegura que no se puede reservar ni liberar una pista que no existe o que está
  reservada por otro usuario.
  """

  use GenServer

  # Iniciar el GenServer con el nombre :CourtDB
  @doc """
  Inicia el GenServer `:CourtDB` con una lista vacía de pistas y usuarios.

  ## Ejemplo

      iex> DB.TablaPistas.start_link()
      {:ok, pid}
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :CourtDB)
  end

  # Función privada para inicializar las pistas y los usuarios

  defp inicializar_pistas_y_usuarios(cantidad) do
    %{
      pistas: Enum.map(1..cantidad, fn num -> %{numero: num, reservada_por: nil} end),
      usuarios: []
    }
  end

  # Callback de init que se llama cuando el GenServer se inicia
  @impl GenServer
  @doc """
  Callback que se ejecuta al iniciar el GenServer. Inicializa el estado con 20 pistas libres.

  ## Ejemplo

      iex> GenServer.call(:CourtDB, :see_all_pistas)
      [%{numero: 1, reservada_por: nil}, ...]
  """
  def init(_) do
    {:ok, inicializar_pistas_y_usuarios(20)}
  end

  # Función para obtener todas las pistas
  @doc """
  Obtiene la lista de todas las pistas disponibles, incluyendo su estado de reserva.

  ## Ejemplo

      iex> DB.TablaPistas.seeAllPistas()
      [%{numero: 1, reservada_por: nil}, ...]
  """
  def seeAllPistas() do
    GenServer.call(:CourtDB, :see_all_pistas)
  end

  # Función para reservar una pista
  @doc """
  Reserva una pista para un usuario, si el usuario existe. Si la pista está disponible,
  se asigna al usuario; si no, se devuelve un error.

  ## Parámetros
    - `usuario`: nombre del usuario que desea hacer la reserva.
    - `numero`: número de la pista a reservar.

  ## Ejemplo

      iex> DB.TablaPistas.reservar_pista("Juan", 1)
      {:ok, "Juan"}
  """
  def reservar_pista(usuario, numero) do
    case DB.TablaUsuarios.existsUser(usuario) do
      {:user_exists} ->
        GenServer.call(:CourtDB, {:reservar_pista, usuario, numero})

      _other ->
        {:error, :usuario_no_existente}
    end
  end

  # Función para liberar una pista
  @doc """
  Libera una pista previamente reservada por un usuario. Solo puede liberarse
  si la pista está reservada por el mismo usuario.

  ## Parámetros
    - `usuario`: nombre del usuario que desea liberar la pista.
    - `numero`: número de la pista a liberar.

  ## Ejemplo

      iex> DB.TablaPistas.liberar_pista("Juan", 1)
      {:ok, 1}
  """
  def liberar_pista(usuario, numero) do
    case DB.TablaUsuarios.existsUser(usuario) do
      {:user_exists} ->
        GenServer.call(:CourtDB, {:liberar_pista, usuario, numero})

      _other ->
        {:error, :usuario_no_existente}
    end
  end

  # Función para ver las reservas de un usuario
  @doc """
  Muestra todas las pistas que un usuario ha reservado.

  ## Parámetros
    - `usuario`: nombre del usuario cuya reserva se desea consultar.

  ## Ejemplo

      iex> DB.TablaPistas.ver_reservas_usuario("Juan")
      [%{numero: 1, reservada_por: "Juan"}]
  """
  def ver_reservas_usuario(usuario) do
    case DB.TablaUsuarios.existsUser(usuario) do
      {:user_exists} ->
        GenServer.call(:CourtDB, {:ver_reservas_usuario, usuario})

      _other ->
        {:error, :usuario_no_existente}
    end
  end

  # Manejar la llamada para obtener todas las pistas
  @impl GenServer
  def handle_call(:see_all_pistas, _, %{pistas: pistas} = state) do
    pistas_sin_reservas =
      Enum.map(pistas, fn %{numero: numero, reservada_por: reservada_por} ->
        %{numero: numero, reservada_por: reservada_por}
      end)

    {:reply, pistas_sin_reservas, state}
  end

  # Manejar la reserva de una pista
  @impl GenServer
  def handle_call({:reservar_pista, usuario, numero_pista}, _from, %{pistas: pistas} = estado) do
    case buscar_pista(pistas, numero_pista) do
      {:ok, pista, nil} ->
        pista_actualizada = %{pista | reservada_por: usuario}
        pistas_actualizadas = actualizar_pista(pistas, numero_pista, pista_actualizada)
        {:reply, {:ok, usuario}, %{estado | pistas: pistas_actualizadas}}

      {:ok, _pista, _otro_usuario} ->
        {:reply, {:error, :pista_ya_reservada}, estado}

      :no_encontrada ->
        {:reply, {:error, :pista_no_existente}, estado}
    end
  end

  # Manejar la liberación de una pista
  @impl GenServer
  def handle_call({:liberar_pista, usuario, numero}, _from, %{pistas: pistas} = state) do
    case buscar_pista(pistas, numero) do
      {:ok, _pista, nil} ->
        {:reply, {:error, :pista_no_reservada}, state}

      {:ok, pista, usuario_reservado} when usuario_reservado == usuario ->
        pista_actualizada = %{pista | reservada_por: nil}
        pistas_actualizadas = actualizar_pista(pistas, numero, pista_actualizada)
        {:reply, {:ok, numero}, %{state | pistas: pistas_actualizadas}}

      {:ok, _pista, _otro_usuario} ->
        {:reply, {:error, :no_autorizado}, state}

      :no_encontrada ->
        {:reply, {:error, :pista_no_existente}, state}
    end
  end

  @impl GenServer
  def handle_call({:ver_reservas_usuario, usuario}, _from, %{pistas: pistas} = state) do
    reservas =
      Enum.filter(pistas, fn %{reservada_por: reservada_por} -> reservada_por == usuario end)

    {:reply, reservas, state}
  end

  # Funciones auxiliares

  defp buscar_pista(pistas, numero) do
    Enum.find_value(pistas, :no_encontrada, fn
      %{numero: n, reservada_por: reservada_por} = pista when n == numero ->
        {:ok, pista, reservada_por}

      _ ->
        nil
    end)
  end

  defp actualizar_pista(pistas, numero, pista_actualizada) do
    Enum.map(pistas, fn
      %{numero: n} = _pista when n == numero -> pista_actualizada
      pista -> pista
    end)
  end
end
