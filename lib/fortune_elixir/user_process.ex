defmodule FortuneElixir.UserProcess do
  use GenServer

  ### Client API

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def lookup(chat_id) do
    GenServer.call(__MODULE__, {:lookup, chat_id})
  end

  def set(chat_id, book) do
    GenServer.cast(__MODULE__, {:set, chat_id, book})
  end

  def remove(chat_id) do
    GenServer.cast(__MODULE__, {:remove, chat_id})
  end

  ### GenServer API

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:lookup, chat_id}, _from, state) do
    {:reply, Map.get(state, chat_id), state}
  end

  @impl true
  def handle_cast({:set, chat_id, book}, state) do
    {:noreply, Map.put(state, chat_id, book)}
  end

  @impl true
  def handle_cast({:remove, chat_id}, state) do
    {:noreply, Map.delete(state, chat_id)}
  end
end
