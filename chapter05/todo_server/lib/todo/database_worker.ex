defmodule Todo.DatabaseWorker do
  use GenServer

  # Public API

  def start_link(db_folder, worker_id) do
    IO.puts "Starting Todo.DatabaseWorker #{worker_id}"
    GenServer.start_link(__MODULE__, db_folder, name: via_tuple(worker_id))
  end

  def store(worker_id, key, data) do
    GenServer.call(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  def clear(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:clear, key})
  end

  # Server implementation

  def init(db_folder) do
    :ok = File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  def handle_call({:get, key}, _, db_folder) do
    data = case File.read(file_path(db_folder, key)) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      _ -> nil
    end
    {:reply, data, db_folder}
  end

  def handle_call({:clear, key}, _, db_folder) do
    File.rm(file_path(db_folder, key))
    {:reply, :ok, db_folder}
  end

  def handle_call({:store, key, data}, _, db_folder) do
    file_path(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))
    {:reply, :ok, db_folder}
  end

  defp file_path(db_folder, key) do
    "#{db_folder}/#{key}"
  end

  defp via_tuple(worker_id) do
    {:via, :gproc, {:n, :l, {:database_worker, worker_id}}}
  end
end
