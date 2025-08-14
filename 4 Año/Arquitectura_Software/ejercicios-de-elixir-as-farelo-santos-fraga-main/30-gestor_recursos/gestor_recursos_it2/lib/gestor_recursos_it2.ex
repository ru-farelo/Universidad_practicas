defmodule GestorRecursos do
  # Función para iniciar el gestor de recursos en modo distribuido
  def start(recursos) do
    pid = spawn(fn -> loop(recursos, %{}) end)
    # Registra el proceso del gestor globalmente
    :global.register_name(:gestor_distribuido, pid)
  end

  # API de interacción del cliente
  def alloc do
    # Envía mensaje al gestor distribuido registrado globalmente
    send(:global.whereis_name(:gestor_distribuido), {:alloc, self()})
    receive do
      {:ok, recurso} -> {:ok, recurso}
      {:error, :sin_recursos} -> {:error, :sin_recursos}
    end
  end

  def release(recurso) do
    # Envía mensaje para liberar el recurso al gestor distribuido
    send(:global.whereis_name(:gestor_distribuido), {:release, self(), recurso})
    receive do
      :ok -> :ok
      {:error, :recurso_no_reservado} -> {:error, :recurso_no_reservado}
    end
  end

  def avail do
    # Consulta los recursos disponibles al gestor distribuido
    send(:global.whereis_name(:gestor_distribuido), {:avail, self()})
    receive do
      num_recursos -> num_recursos
    end
  end

  # Ciclo de vida del gestor
  defp loop(recursos_disponibles, asignaciones) do
    receive do
      # Solicitud de asignar un recurso
      {:alloc, from_pid} ->
        case recursos_disponibles do
          [recurso | recursos_restantes] ->
            asignaciones_actualizadas = Map.put(asignaciones, recurso, from_pid)
            send(from_pid, {:ok, recurso})
            loop(recursos_restantes, asignaciones_actualizadas)

          [] ->
            send(from_pid, {:error, :sin_recursos})
            loop(recursos_disponibles, asignaciones)
        end

      # Solicitud de liberar un recurso
      {:release, from_pid, recurso} ->
        case Map.get(asignaciones, recurso) do
          ^from_pid ->  # Verifica si el proceso que libera es el que reservó
            asignaciones_actualizadas = Map.delete(asignaciones, recurso)
            send(from_pid, :ok)
            loop([recurso | recursos_disponibles], asignaciones_actualizadas)

          _ ->
            send(from_pid, {:error, :recurso_no_reservado})
            loop(recursos_disponibles, asignaciones)
        end

      # Solicitud de consultar los recursos disponibles
      {:avail, from_pid} ->
        send(from_pid, length(recursos_disponibles))
        loop(recursos_disponibles, asignaciones)
    end
  end
end

defmodule Cliente do
  def reservar do # Solicita un recurso
    case GestorRecursos.alloc() do
      {:ok, recurso} ->
        IO.puts("Recurso reservado: #{inspect(recurso)}")
        recurso

      {:error, :sin_recursos} ->
        IO.puts("No hay recursos disponibles.")
        nil
    end
  end

  def liberar(recurso) when not is_nil(recurso) do # Recibe el recurso a liberar
    case GestorRecursos.release(recurso) do
      :ok ->
        IO.puts("Recurso liberado: #{inspect(recurso)}")

      {:error, :recurso_no_reservado} ->
        IO.puts("Error: el recurso #{inspect(recurso)} no fue reservado por este proceso.")
    end
  end

  def recursos_disponibles do
    IO.puts("Recursos disponibles: #{GestorRecursos.avail()}")
  end
end

#mix new gestor_recursos_distribuido
#cd gestor_recursos_distribuido

#iex --sname gestor@localhost --cookie secreto -S mix

#GestorRecursos.start(["Recurso1", "Recurso2", "Recurso3"])

#En un nuevo terminal:
#iex --sname cliente1@localhost --cookie secreto -S mix
#Node.connect(:"gestor@localhost")
#Node.list()
#Cliente.reservar()
#Cliente.liberar("Recurso1")
#Cliente.recursos_disponibles()
