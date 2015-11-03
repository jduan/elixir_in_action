defmodule KeyvalueStore2 do
  use GenServer

  def start do
    {:ok, pid} = GenServer.start(KeyvalueStore2, nil)
    pid
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def size(pid) do
    GenServer.call(pid, {:size})
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def delete(pid, key) do
    GenServer.cast(pid, {:delete, key})
  end

  # implementation detail
  def init(_) do
    {:ok, Map.new}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_call({:size}, _, state) do
    {:reply, Map.size(state), state}
  end
end
