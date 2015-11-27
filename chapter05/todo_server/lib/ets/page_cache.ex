defmodule ETS.PageCache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def cached(path, callback) do
    GenServer.call(__MODULE__, {:cached, path, callback})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:cached, path, callback}, _, cache) do
    page = case Map.get(cache, path) do
      nil ->
        callback.()
      cached ->
        cached
    end

    {:reply, page, Map.put(cache, path, page)}
  end
end
