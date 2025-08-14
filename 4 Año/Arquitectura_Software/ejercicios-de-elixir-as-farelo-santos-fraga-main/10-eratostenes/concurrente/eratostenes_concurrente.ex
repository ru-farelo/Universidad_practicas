defmodule Primos do
  def iniciar_proceso_primo_inicial(limite) when limite > 2 do
    lista_numeros = Enum.to_list(3..limite)
    parent = self()
    primer_proceso = spawn(fn -> proceso_primo(2, parent, [2]) end)
    enviar_numeros(lista_numeros, primer_proceso)  # Enviamos los números del 3 a n de la lista uno por uno al proceso 2
    #send(primer_proceso, :hemos_terminado)    # Enviamos el mensaje de "hemos terminado" para indicar que ya no hay más números
    send(primer_proceso, {:hemos_terminado, self()}) # alternativa sería incluir la referencia a self en el mensaje final {:hemos_terminado, self()
    recibir_lista_primos()    # Recibimos la lista de primos del proceso final
  end

  defp enviar_numeros([], _proceso) do
    :ok
  end

  defp enviar_numeros([numero | resto], proceso) do
    send(proceso, {:numero, numero}) # Enviamos el número al proceso
    enviar_numeros(resto, proceso)
  end

  defp proceso_primo(primo, parent, primos_acumulados) do
    receive do
      {:numero, numero} ->
        # El primer número que llega sabemos que es primo, por lo que lo utilizamos para crear el siguiente proceso y añadimos el numero a la lista de primos
        siguiente_proceso = spawn(fn -> proceso_primo(numero, parent, [numero | primos_acumulados]) end)
        transferir_restantes(siguiente_proceso, primo)
      #:hemos_terminado ->
       # send(parent, {:resultado_primos, Enum.reverse(primos_acumulados)})  # Cuando recibimos "hemos terminado", sabemos que este es el último proceso

      {:hemos_terminado, sender} ->#alternativa sería incluir la referencia a self en el mensaje final {:hemos_terminado, self()
        send(sender, {:resultado_primos, Enum.reverse(primos_acumulados)})
      end
  end



  defp transferir_restantes(siguiente_proceso, primo) do
    # Enviamos al siguiente proceso todos los números según vayan llegando y comprobando que no son múltiplos
    receive do
      {:numero, numero} when rem(numero, primo) != 0 -> #  Corregido y hacemos uso con guardas
        # Si el número no es múltiplo del primo, lo enviamos al siguiente proceso
        send(siguiente_proceso, {:numero, numero})
        transferir_restantes(siguiente_proceso, primo) # Seguimos recibiendo números

      {:numero, _numero} ->
        # Si el número es múltiplo del primo, simplemente lo ignoramos y seguimos recibiendo números
        transferir_restantes(siguiente_proceso, primo)

      #:hemos_terminado ->
        # Cuando recibimos "hemos terminado", enviamos el mensaje al siguiente proceso
        #send(siguiente_proceso, :hemos_terminado)

      {:hemos_terminado, sender} -> #alternativa sería incluir la referencia a self en el mensaje final {:hemos_terminado, self()
        send(siguiente_proceso, {:hemos_terminado, sender})
    end
  end

  defp recibir_lista_primos() do
    receive do
      {:resultado_primos, primos} -> primos # Recibimos la lista de primos
    end
  end
end
