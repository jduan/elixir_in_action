# TodoCache is used to start TodoServer based on name.
defmodule TodoCache do
  use GenServer
  @alias __MODULE__

  # Public API

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: @alias)
  end

  def server_process(name) do
    GenServer.call(@alias, {:server_process, name})
  end

  # Server implementation

  def init(_) do
    TodoDatabase.start_link("./persist/")
    {:ok, %{}}
  end

  def handle_call({:server_process, name}, _, cache) do
    case Map.fetch(cache, name) do
      {:ok, pid} ->
        {:reply, pid, cache}
      :error ->
        pid = TodoServer.start_link(name)
        {:reply, pid, Map.put(cache, name, pid)}
    end
  end
end
