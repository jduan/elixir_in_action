# A process that can be used to store and retrieve any Erlang term.
# It's generic and it isn't TodoList specific.
defmodule TodoDatabase do
  use GenServer

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

  def handle_call({:store, key, data}, _, db_folder) do
    file_path(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))
    {:reply, :ok, db_folder}
  end

  def handle_call({:clear}, _, db_folder) do
    File.rm_rf!(db_folder)
    {:reply, :ok, db_folder}
  end

  defp file_path(db_folder, key) do
    "#{db_folder}/#{key}"
  end
end
