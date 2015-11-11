# A process that can be used to store and retrieve any Erlang term.
# It's generic and it isn't TodoList specific.
defmodule TodoDatabase do
  use GenServer

  @num_of_workers 3

  # Public API

  def start_link(db_folder) do
    GenServer.start_link(__MODULE__, db_folder, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.call(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  # clear all the files in the database
  def clear do
    GenServer.call(__MODULE__, {:clear})
  end

  # Server implementation

  def init(db_folder) do
    num_to_worker = spawn_workers(db_folder)
    :ok = File.mkdir_p(db_folder)
    {:ok, {db_folder, num_to_worker}}
  end

  def handle_call({:get, key}, _, state = {db_folder, num_to_worker}) do
    worker_pid = find_worker(key, num_to_worker)
    data = TodoDatabaseWorker.get(worker_pid, key)
    {:reply, data, state}
  end

  def handle_call({:store, key, data}, _, state = {db_folder, num_to_worker}) do
    worker_pid = find_worker(key, num_to_worker)
    TodoDatabaseWorker.store(worker_pid, key, data)

    {:reply, :ok, state}
  end

  def handle_call({:clear}, _, state = {db_folder, _num_to_worker}) do
    File.rm_rf!(db_folder)
    {:reply, :ok, state}
  end

  defp spawn_workers(db_folder) do
    1..@num_of_workers
    |> Enum.reduce(%{}, fn i, map ->
      pid = TodoDatabaseWorker.start_link(db_folder)
      Map.put(map, i-1, pid)
    end)
  end

  defp find_worker(key, num_to_worker) do
    worker_number = rem(:erlang.phash2(key), @num_of_workers)
    IO.puts("worker_number: #{worker_number}")
    IO.puts("num_to_worker: #{inspect num_to_worker}")
    num_to_worker[worker_number]
  end
end
