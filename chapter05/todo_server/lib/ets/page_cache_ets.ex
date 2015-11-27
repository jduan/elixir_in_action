defmodule ETS.PageCacheETS do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def cached(key, callback) do
    read_cached(key) ||
      GenServer.call(__MODULE__, {:cached, key, callback})
  end

  def init(_) do
    :ets.new(:ets_page_cache, [:set, :protected, :named_table])
    {:ok, nil}
  end

  def handle_call({:cached, key, callback}, _, state) do
    {
      :reply,
      read_cached(key) || cache_response(key, callback),
      state
    }
  end

  defp read_cached(key) do
    case :ets.lookup(:ets_page_cache, key) do
      [{^key, cached}] -> cached
      [] -> nil
    end
  end

  defp cache_response(key, callback) do
    response = callback.()
    :ets.insert(:ets_page_cache, {key, response})
    response
  end
end
