defmodule GestorRecursos do
  require Logger

  def start(recursos) do
    pid = spawn(fn -> loop(recursos, %{}, %{}) end)
    :global.register_name(:gestor, pid)

    # Activa el monitoreo de nodos
    :net_kernel.monitor_nodes(true)
  end

  def alloc do
    send(:gestor, {:alloc, self()})
    receive do
      {:ok, recurso} -> {:ok, recurso}
      {:error, :sin_recursos} -> {:error, :sin_recursos}
    end
  end

  def release(recurso) do
    send(:gestor, {:release, self(), recurso})
    receive do
      :ok -> :ok
      {:error, :recurso_no_reservado} -> {:error, :recurso_no_reservado}
    end
  end

  def avail do
    send(:gestor, {:avail, self()})
    receive do
      num_recursos -> num_recursos
    end
  end

  # Ciclo de vida del gestor de recursos
  defp loop(recursos_disponibles, asignaciones, monitores) do
    receive do
      {:nodeup, nodo} ->
        IO.puts("Nodo conectado: #{inspect(nodo)}")  # Usar inspect para mostrar el nodo
        loop(recursos_disponibles, asignaciones, monitores)

      {:nodedown, nodo} ->
        IO.puts("Nodo desconectado: #{inspect(nodo)}")  # Usar inspect para evitar errores de conversión

        # Aquí se libera cualquier recurso asignado a procesos del nodo caído
        {recursos_disponibles_actualizados, asignaciones_actualizadas, monitores_actualizados} =
          liberar_recursos_por_nodo(nodo, recursos_disponibles, asignaciones, monitores)

        loop(recursos_disponibles_actualizados, asignaciones_actualizadas, monitores_actualizados)

      {:alloc, from_pid} ->
        case recursos_disponibles do
          [recurso | recursos_restantes] ->
            ref = Process.monitor(from_pid)
            asignaciones_actualizadas = Map.put(asignaciones, recurso, {from_pid, ref})
            monitores_actualizados = Map.put(monitores, ref, recurso)
            send(from_pid, {:ok, recurso})
            loop(recursos_restantes, asignaciones_actualizadas, monitores_actualizados)

          [] ->
            send(from_pid, {:error, :sin_recursos})
            loop(recursos_disponibles, asignaciones, monitores)
        end

      {:release, from_pid, recurso} ->
        case Map.get(asignaciones, recurso) do
          {^from_pid, ref} ->
            Process.demonitor(ref, [:flush])
            asignaciones_actualizadas = Map.delete(asignaciones, recurso)
            monitores_actualizados = Map.delete(monitores, ref)
            send(from_pid, :ok)
            loop([recurso | recursos_disponibles], asignaciones_actualizadas, monitores_actualizados)

          _ ->
            send(from_pid, {:error, :recurso_no_reservado})
            loop(recursos_disponibles, asignaciones, monitores)
        end

      {:avail, from_pid} ->
        send(from_pid, length(recursos_disponibles))
        loop(recursos_disponibles, asignaciones, monitores)

      {:DOWN, ref, :process, _pid, _reason} ->
        case Map.get(monitores, ref) do
          nil ->
            loop(recursos_disponibles, asignaciones, monitores)

          recurso ->
            IO.puts("Proceso cliente ha fallado, liberando recurso #{inspect(recurso)}")
            asignaciones_actualizadas = Map.delete(asignaciones, recurso)
            monitores_actualizados = Map.delete(monitores, ref)
            loop([recurso | recursos_disponibles], asignaciones_actualizadas, monitores_actualizados)
        end
    end
  end

  defp liberar_recursos_por_nodo(nodo, recursos_disponibles, asignaciones, monitores) do
    recursos_liberados =
      for {recurso, {pid, ref}} <- asignaciones,
          node(pid) == nodo,
          into: [] do
        Process.demonitor(ref, [:flush])
        recurso
      end

    asignaciones_actualizadas = Map.drop(asignaciones, recursos_liberados)
    monitores_actualizados = Enum.reduce(monitores, %{}, fn {ref, recurso}, acc ->
      case Map.get(asignaciones_actualizadas, recurso) do
        nil -> acc
        _ -> Map.put(acc, ref, recurso)
      end
    end)

    {[recursos_liberados | recursos_disponibles], asignaciones_actualizadas, monitores_actualizados}
  end

end


defmodule Cliente do
  def reservar do
    case :global.whereis_name(:gestor) do
      :undefined ->
        IO.puts("No se pudo encontrar el gestor de recursos.")
        nil

      pid ->
        send(pid, {:alloc, self()})
        receive do
          {:ok, recurso} ->
            IO.puts("Recurso reservado: #{inspect(recurso)}")
            recurso

          {:error, :sin_recursos} ->
            IO.puts("No hay recursos disponibles.")
            nil
        end
    end
  end

  def liberar(recurso) when not is_nil(recurso) do
    case :global.whereis_name(:gestor) do
      :undefined ->
        IO.puts("No se pudo encontrar el gestor de recursos.")

      pid ->
        send(pid, {:release, self(), recurso})
        receive do
          :ok ->
            IO.puts("Recurso liberado: #{inspect(recurso)}")

          {:error, :recurso_no_reservado} ->
            IO.puts("Error: el recurso #{inspect(recurso)} no fue reservado por este proceso.")
        end
    end
  end

  def recursos_disponibles do
    case :global.whereis_name(:gestor) do
      :undefined ->
        IO.puts("No se pudo encontrar el gestor de recursos.")
        0

      pid ->
        send(pid, {:avail, self()})
        receive do
          num_recursos when is_integer(num_recursos) ->
            IO.puts("Recursos disponibles: #{num_recursos}")
            num_recursos

          # Aquí usamos inspect en caso de que reciba un mensaje `:nodedown` o similar

        end
    end
  end
end


#iex --sname gestor@localhost --cookie secreto -S mix

#GestorRecursos.start(["Recurso1", "Recurso2", "Recurso3"])

#En un nuevo terminal:
#iex --sname cliente1@localhost --cookie secreto -S mix
#Node.connect(:"gestor@localhost")
#Node.list()
#Cliente.reservar()
#terminar el proceso cerrando el iex o matando la terminal.
#
#
#Desde la maquina gestor comprobar que el recurso se ha liberado correctamente después
# de terminar el proceso
#Cliente.recursos_disponibles()
