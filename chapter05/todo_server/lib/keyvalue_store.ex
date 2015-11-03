defmodule KeyvalueStore do
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
