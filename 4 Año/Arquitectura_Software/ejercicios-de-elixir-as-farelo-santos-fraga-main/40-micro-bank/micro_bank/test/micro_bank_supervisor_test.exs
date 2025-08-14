defmodule MicroBankSupervisorTest do
  use ExUnit.Case

  setup do
    {:ok, _sup_pid} = MicroBankSupervisor.start_link([])
    :ok
  end

  test "supervisor restarts server on failure" do
    pid_before = Process.whereis(MicroBankServer)  # Comprobar que el servidor está en marcha
    assert pid_before != nil

    Process.exit(pid_before, :kill)   # Matar el servidor

    Process.sleep(100)  # Esperar un poco para darle tiempo al supervisor a reiniciar el servidor

    pid_after = Process.whereis(MicroBankServer)   # Comprobar que el servidor se ha reiniciado
    assert pid_after != nil

    assert pid_before != pid_after   # Asegurarse de que los PIDs no son los mismos (el proceso ha sido reiniciado)
  end
end
