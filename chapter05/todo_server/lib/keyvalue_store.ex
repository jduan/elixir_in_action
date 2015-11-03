defmodule KeyvalueStore do
  # public API
  def new do
    ServerProcess.start(KeyvalueStore)
  end

  def put(store, key, value) do
    ServerProcess.call(store, {:put, key, value})
  end

  def get(store, key) do
    ServerProcess.call(store, {:get, key})
  end

  # implementaion detail
  def init do
    Map.new
  end

  def handle_call({:put, key, value}, map) do
    {:ok, Map.put(map, key, value)}
  end

  def handle_call({:get, key}, map) do
    {Map.get(map, key), map}
  end
end
