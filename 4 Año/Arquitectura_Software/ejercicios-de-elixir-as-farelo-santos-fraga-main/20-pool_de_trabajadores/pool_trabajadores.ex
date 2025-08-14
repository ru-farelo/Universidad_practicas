defmodule Trabajador do
  def iniciar do
    recibir_trabajo()
  end

  defp recibir_trabajo() do
    receive do
      {:trabajo, from, func, index} ->
        resultado = func.()
        send(from, {:resultado, self(), resultado, index})
        recibir_trabajo()

      :stop -> :ok
    end
  end
end

defmodule Servidor do
  def iniciar(n) do
    pid = spawn(fn -> crear_trabajadores(n) end)
    {:ok, pid}
  end

  def enviar_trabajos(pid, trabajos) do
    send(pid, {:trabajos, self(), trabajos})

    receive do
      {:resultados, resultados} -> resultados
    end
  end

  def detener_servidor(pid) do
    send(pid, {:stop, self()})
    receive do
      :ok -> :servidor_detenido
    end
  end

  defp crear_trabajadores(n) do
    trabajadores = Enum.map(1..n, fn _ -> spawn(Trabajador, :iniciar, []) end)
    recibir_trabajos(trabajadores, [])
  end

  defp recibir_trabajos(trabajadores, cola_pendientes) do
    receive do
      {:trabajos, from, trabajos} ->
        trabajos_con_index = Enum.with_index(trabajos) # asignar índices a los trabajos
        spawn(fn -> procesar_lote(trabajadores, trabajos_con_index, from, cola_pendientes) end)
        recibir_trabajos(trabajadores, cola_pendientes)

      {:stop, from} ->
        Enum.each(trabajadores, fn trabajador -> send(trabajador, :stop) end)
        send(from, :ok)
    end
  end

  defp procesar_lote(trabajadores, trabajos, from, cola_pendientes) do
    trabajos_totales = length(trabajos)
    {trabajos_a_asignar, trabajos_restantes} = Enum.split(trabajos, length(trabajadores))  # asignar trabajos a los trabajadores, y si hay más trabajos que trabajadores, agregar a la cola
    Enum.each(trabajos_a_asignar, fn {trabajo, index} ->
      pid = Enum.at(trabajadores, rem(index, length(trabajadores)))
      send(pid, {:trabajo, self(), trabajo, index})
    end)
    recibir_resultados(trabajadores, from, trabajos_totales, trabajos_restantes ++ cola_pendientes, [])
  end

  defp recibir_resultados(trabajadores, from, total_trabajos, cola_pendientes, resultados) do
    if length(resultados) == total_trabajos do   # enviar resultados al cliente cuando todos los trabajos están completados
      send(from, {:resultados, Enum.sort_by(resultados, fn {_, index} -> index end)})
    else
      receive do
        {:resultado, pid_libre, resultado, index} ->
          nuevos_resultados = [{resultado, index} | resultados]
          case cola_pendientes do   # ver si hay trabajos pendientes para asignar a los trabajadores libres
            [] ->    # si no hay trabajos pendientes, continuar recibiendo resultados
              recibir_resultados(trabajadores, from, total_trabajos, cola_pendientes, nuevos_resultados)

            [{trabajo, nuevo_index} | restantes] ->   # asignar trabajo pendiente al trabajador que acaba de liberar
              send(pid_libre, {:trabajo, self(), trabajo, nuevo_index})
              recibir_resultados(trabajadores, from, total_trabajos, restantes, nuevos_resultados)
          end
      end
    end
  end
end
