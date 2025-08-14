defmodule Easycourt do
  @moduledoc """
  **Easycourt** es el punto de entrada para iniciar la aplicación. Se encarga de iniciar
  los componentes principales del sistema, incluyendo el supervisor y el inicio de los entornos de cliente o administrador.

  El módulo utiliza un ciclo de vida de la aplicación (`Application` behavior) y proporciona funciones para iniciar
  un entorno de cliente o administrador, con las instancias de Directorioes correspondientes inicializadas.

  ## Ciclo de Vida de la Aplicación

  La función `start/2` se utiliza para iniciar el árbol de supervisión de la aplicación. El componente principal del
  árbol de supervisión es `MiSupervisor`.

  ## API Pública

  - `start/2`: Inicia el árbol de supervisión de la aplicación.
  - `start_cliente/0`: Inicia el entorno de cliente inicializando los Directorioes y ejecutando la lógica del cliente.
  - `start_admin/0`: Inicia el entorno de administrador inicializando los Directorioes y ejecutando la lógica del administrador.

  ## Ejemplo

      # Iniciando la aplicación
      Easycourt.start(:normal, [])

      # Iniciando el entorno de cliente
      Easycourt.start_cliente()

      # Iniciando el entorno de administrador
      Easycourt.start_admin()
  """
  use Application

  @doc """
  Inicia el árbol de supervisión de la aplicación.

  Esta función se llama cuando la aplicación se inicia. Inicializa el supervisor principal (`MiSupervisor`)
  y utiliza la estrategia `one_for_one` para la supervisión de procesos.

  ## Argumentos:
    - `_type`: El tipo de inicio de la aplicación (por ejemplo, `:normal`).
    - `_args`: Argumentos pasados a la función `start` (ignorados en esta implementación).

  ## Retorna:
    - `{:ok, pid}`: Una tupla que contiene el PID del supervisor.
  """
  def start(_type, _args) do
    children = [
      {MiSupervisor, []}
    ]

    opts = [strategy: :one_for_one, name: MiApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Inicia el entorno de cliente.

  Esta función inicializa los Directorioes necesarios (Directorioes de carga) y
  luego ejecuta la función `Cliente.main/1` para manejar la lógica del lado del cliente.

  ## Retorna:
    - El resultado de ejecutar la función `Cliente.main/1`, que dependerá de la lógica del cliente.
  """
  def start_cliente do
    directorios = Directorio.iniciarArquitecturaPids()
    Cliente.main(directorios)
  end

  @doc """
  Inicia el entorno de administrador.

  Esta función inicializa los Directorioes necesarios (Directorioes de carga) y
  luego ejecuta la función `Admin.main/1` para manejar la lógica del lado del administrador.

  ## Retorna:
    - El resultado de ejecutar la función `Admin.main/1`, que dependerá de la lógica del administrador.
  """
  def start_admin do
    directorios = Directorio.iniciarArquitecturaPids()
    Admin.main(directorios)
  end
end
