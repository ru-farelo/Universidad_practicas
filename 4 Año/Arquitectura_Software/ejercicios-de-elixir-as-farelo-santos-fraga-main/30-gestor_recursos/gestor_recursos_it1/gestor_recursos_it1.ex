#Version no Distribuida
defmodule GestorRecursos do
  # Función para iniciar el gestor de recursos
  def start(recursos) do
    pid = spawn(fn -> loop(recursos, %{}) end)
    Process.register(pid, :gestor)
  end

  # API de interacción del cliente
  def alloc do # Solicita un recurso
    send(:gestor, {:alloc, self()})
    receive do
      {:ok, recurso} -> {:ok, recurso}
      {:error, :sin_recursos} -> {:error, :sin_recursos}
    end
  end

  def release(recurso) do # Recibe el recurso a liberar
    send(:gestor, {:release, self(), recurso})
    receive do
      :ok -> :ok
      {:error, :recurso_no_reservado} -> {:error, :recurso_no_reservado}
    end
  end

  def avail do # Consulta los recursos disponibles
    send(:gestor, {:avail, self()})
    receive do
      num_recursos -> num_recursos
    end
  end

  # Función que implementa el ciclo de vida del gestor
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
            # Reintegra el recurso liberado a la lista de recursos disponibles
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

# Cliente
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

# Uso prueba basica
#c("gestor_recursos_it1.ex")
#GestorRecursos.start([:a, :b, :c, :d])

# Ejemplo de uso del cliente
#Cliente.reservar()
#Cliente.reservar()

#Cliente.recursos_disponibles()

#Cliente.liberar(:a)
#Cliente.liberar(:b)

#Cliente.recursos_disponibles()

# Probar a liberar un recurso no reservado
#Cliente.liberar(:d)
