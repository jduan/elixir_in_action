# TodoCache is used to start TodoServer based on name.
defmodule TodoCache do
  use GenServer
  @alias __MODULE__

  # Public API

  def start_link(db_folder) do
    GenServer.start_link(__MODULE__, db_folder, name: @alias)
  end

  def server_process(name) do
    GenServer.call(@alias, {:server_process, name})
  end

  # Server implementation

  def init(db_folder) do
    # This is a hack. There must be a better way to start TodoDatabase
    TodoDatabase.start_link(db_folder)
    {:ok, {db_folder, %{}}}
  end

  def handle_call({:server_process, name}, _, {db_folder, cache}) do
    case Map.fetch(cache, name) do
      {:ok, pid} ->
        {:reply, pid, {db_folder, cache}}
      :error ->
        pid = TodoServer.start_link(name)
        {:reply, pid, {db_folder, Map.put(cache, name, pid)}}
    end
  end
end
