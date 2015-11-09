defmodule TodoDatabase do
  use GenServer

  def start(db_folder) do
    IO.puts("starting TodoDatabase: #{db_folder}")
    GenServer.start(__MODULE__, db_folder, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.call(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  # Remove all the persisted database entries
  def clear do
    GenServer.call(__MODULE__, {:clear})
  end

  # Stop the process
  def stop do
    Process.exit(Process.whereis(__MODULE__), :kill)
    IO.puts("Stopped the TodoDatabase process")
  end

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
    IO.puts("key: #{key}")
    file_path(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))
    {:reply, :ok, db_folder}
  end

  def handle_call({:clear}, _, db_folder) do
    File.rm_rf(db_folder)
    {:reply, :ok, db_folder}
  end

  defp file_path(db_folder, key) do
    "#{db_folder}/#{key}"
  end
end
