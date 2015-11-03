defmodule KeyvalueStore do
  # public API
  def new do
    ServerProcess.start(KeyvalueStore)
  end

  def put(store, key, value) do
    ServerProcess.cast(store, {:put, key, value})
  end

  def get(store, key) do
    ServerProcess.call(store, {:get, key})
  end

  def delete(store, key) do
    ServerProcess.cast(store, {:delete, key})
  end

  def size(store) do
    ServerProcess.call(store, {:size})
  end

  # implementaion detail
  def init do
    Map.new
  end

  def handle_cast({:put, key, value}, map) do
    Map.put(map, key, value)
  end

  def handle_cast({:delete, key}, map) do
    Map.delete(map, key)
  end

  def handle_call({:get, key}, map) do
    {Map.get(map, key), map}
  end

  def handle_call({:size}, map) do
    {Map.size(map), map}
  end
end
