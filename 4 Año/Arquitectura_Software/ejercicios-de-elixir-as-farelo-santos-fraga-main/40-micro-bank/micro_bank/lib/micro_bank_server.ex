defmodule MicroBankServer do
  use GenServer

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def stop do
    GenServer.stop(__MODULE__, :normal)
  end

  def deposit(who, amount) do
    GenServer.call(__MODULE__, {:deposit, who, amount})
  end

  def ask(who) do
    GenServer.call(__MODULE__, {:ask, who})
  end

  def withdraw(who, amount) do
    GenServer.call(__MODULE__, {:withdraw, who, amount})
  end


  @impl true
  def init(_initial_state) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:deposit, who, amount}, _from, state) do
    new_balance = Map.get(state, who, 0) + amount
    new_state = Map.put(state, who, new_balance)
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:ask, who}, _from, state) do
    balance = Map.get(state, who, 0)
    {:reply, balance, state}
  end

  @impl true
  def handle_call({:withdraw, who, amount}, _from, state) do
    current_balance = Map.get(state, who, 0)

    if current_balance >= amount do
      new_balance = current_balance - amount
      new_state = Map.put(state, who, new_balance)
      {:reply, :ok, new_state}
    else
      {:reply, {:error, :insufficient_funds}, state}
    end
  end
end
