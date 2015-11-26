# A process that can be used to store and retrieve any Erlang term.
# It's generic and it isn't TodoList specific.
defmodule TodoDatabase do
  use GenServer

  @pool_size 3

  # Public API

  def start_link(db_folder) do
    IO.puts "Starting TodoDatabase Server"
    Todo.PoolSupervisor.start_link(db_folder, @pool_size)
  end

  def store(key, data) do
    key
    |> choose_worker
    |> TodoDatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker
    |> TodoDatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
end
