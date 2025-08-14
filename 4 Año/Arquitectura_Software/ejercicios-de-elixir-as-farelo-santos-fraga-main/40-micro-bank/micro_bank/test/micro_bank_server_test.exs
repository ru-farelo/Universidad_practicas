defmodule MicroBankServerTest do
  use ExUnit.Case

  setup do
    {:ok, _pid} = MicroBankServer.start_link([])
    :ok
  end

  test "deposit and ask balance" do
    assert :ok == MicroBankServer.deposit("Alice", 100)
    assert 100 == MicroBankServer.ask("Alice")
  end

  test "withdraw money" do
    MicroBankServer.deposit("Alice", 100)
    assert :ok == MicroBankServer.withdraw("Alice", 50)
    assert 50 == MicroBankServer.ask("Alice")
  end

  test "insufficient funds" do
    MicroBankServer.deposit("Alice", 100)
    assert {:error, :insufficient_funds} == MicroBankServer.withdraw("Alice", 200)
    assert 100 == MicroBankServer.ask("Alice")
  end
end
