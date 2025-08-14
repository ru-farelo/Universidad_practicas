defmodule MiSupervisor do
  @moduledoc """
  **MiSupervisor** es un módulo Supervisor responsable de gestionar el ciclo de vida de los procesos hijos, incluidos
  `Directorio`, `ServidorCliente`, `ServidorAdmin`, `Cliente` y `Admin`. El supervisor usa la estrategia `:one_for_one`,
  lo que significa que si un proceso hijo falla, solo ese proceso se reinicia.

  ## Responsabilidades clave
  - Inicia y supervisa múltiples procesos hijos.
  - Inicializa dependencias como las bases de datos de usuarios y canchas (`DB.TablaUsuarios` y `DB.TablaPistas`).
  - Proporciona un mecanismo para agregar procesos hijos de manera dinámica.

  ## API Pública

  - `start_link/1`: Inicia el supervisor y su conjunto inicial de procesos hijos.
  - `init/1`: Inicializa el supervisor con los procesos hijos predefinidos y las conexiones a la base de datos.
  - `add_child_to_supervisor/0`: Agrega dinámicamente un nuevo proceso hijo al supervisor.

  ## Ejemplo

      # Iniciar el supervisor
      {:ok, pid} = MiSupervisor.start_link([])

      # Agregar un nuevo hijo de manera dinámica
      MiSupervisor.add_child_to_supervisor()

      # Obtener información sobre los hijos del supervisor
      Supervisor.count_children(pid)
      Supervisor.which_children(pid)

      # Interactuar con un proceso hijo (por ejemplo, obtener su pid)
      pid = Process.whereis(Cliente)

      # Simular una falla en un proceso hijo
      Process.exit(pid, :kill)

      # Verificar si el proceso hijo fue reiniciado
      Supervisor.which_children(pid)
      Process.alive?(pid)
  """
  use Supervisor

  @doc """
  Inicia el supervisor e inicializa los procesos hijos necesarios.

  ## Argumentos:
    - `_`: Un marcador de posición para los argumentos pasados a `start_link/1`.

  ## Retorna:
    - `{:ok, pid}`: El PID del supervisor.
  """
  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Inicializa el supervisor con los procesos hijos predefinidos y las conexiones a las bases de datos.

  Esta función también inicia las bases de datos `DB.TablaUsuarios` y `DB.TablaPistas`
  antes de especificar los procesos hijos que el supervisor gestionará.

  ## Argumentos:
    - `:ok`: Un argumento marcador de posición utilizado para activar la inicialización.

  ## Retorna:
    - `{:ok, state}`: Una tupla con `:ok` y el estado inicial del supervisor.
  """
  def init(:ok) do
    # Inicializar las bases de datos
    {:ok, _} = DB.TablaUsuarios.start_link()
    {:ok, _} = DB.TablaPistas.start_link()

    # Definir los procesos hijos que serán supervisados
    children = [
      {Directorio, []},
      {ServidorCliente, [1]},
      {ServidorAdmin, [2]},
      {Cliente, []},
      {Admin, []}
    ]

    # Iniciar el supervisor con la estrategia :one_for_one
    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Agrega dinámicamente un nuevo proceso hijo al supervisor.

  Esta función utiliza `Supervisor.start_child` para agregar una nueva instancia del módulo `Cliente`
  al supervisor, permitiendo la escalabilidad dinámica del sistema.

  ## Argumentos:
    - Ninguno

  ## Retorna:
    - `:ok`: Indica que el proceso hijo fue iniciado correctamente.
  """
  def add_child_to_supervisor() do
    # Definir la especificación del proceso hijo
    child_spec = {Cliente, []}

    # Agregar el proceso hijo de manera dinámica
    Supervisor.start_child(__MODULE__, child_spec)
  end
end
