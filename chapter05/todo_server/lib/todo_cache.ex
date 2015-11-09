defmodule TodoCache do
  use GenServer
  @alias __MODULE__

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: @alias)
  end

  def server_process(name) do
    GenServer.call(@alias, {:server_process, name})
  end

  # Stop all the TodoServers
  def clear do
    GenServer.call(@alias, {:clear})
  end

  def stop do
    Process.exit(Process.whereis(@alias), :kill)
  end

  def init(db_folder) do
    TodoDatabase.start(db_folder)
    {:ok, {db_folder, %{}}}
  end

  def handle_call({:server_process, name}, _, {db_folder, cache}) do
    case Map.fetch(cache, name) do
      {:ok, pid} ->
        {:reply, pid, {db_folder, cache}}
      :error ->
        pid = TodoServer.start(name)
        {:reply, pid, {db_folder, Map.put(cache, name, pid)}}
    end
  end

  def handle_call({:clear}, _, {db_folder, cache}) do
    cache
    |> Enum.each(fn {_name, pid} ->
      Process.exit(pid, :kill)
    end)

    {:reply, :ok, {db_folder, %{}}}
  end
end
