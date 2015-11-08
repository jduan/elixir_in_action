defmodule TodoDatabase do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.call(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def init(db_folder) do
    :ok = File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  def handle_call({:get, key}, _, db_folder) do
    {:ok, data} = File.read(file_path(db_folder, key))
    {:reply, :erlang.binary_to_term(data), db_folder}
  end

  def handle_call({:store, key, data}, _, db_folder) do
    file_path(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))
    {:reply, :ok, db_folder}
  end

  defp file_path(db_folder, key) do
    "#{db_folder}/#{key}"
  end
end
