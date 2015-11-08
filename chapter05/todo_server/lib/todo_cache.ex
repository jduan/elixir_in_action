defmodule TodoCache do
  use GenServer
  @alias __MODULE__

  def start do
    GenServer.start(__MODULE__, nil, name: @alias)
  end

  def server_process(name) do
    GenServer.call(@alias, {:server_process, name})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:server_process, name}, _, cache) do
    case Map.fetch(cache, name) do
      {:ok, pid} ->
        {:reply, pid, cache}
      :error ->
        pid = TodoServer.start
        {:reply, pid, Map.put(cache, name, pid)}
    end
  end
end
