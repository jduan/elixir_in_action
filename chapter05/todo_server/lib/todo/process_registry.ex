defmodule Todo.ProcessRegistry do
  use GenServer
  @ets_table :ets_progress_registry

  # Public API

  def start_link do
    IO.puts "Starting Todo.ProcessRegistry"
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # writes are serialized in the "registry" process
  def register_name(name, pid) do
    GenServer.call(__MODULE__, {:register_name, name, pid})
  end

  def unregister_name(name) do
    GenServer.call(__MODULE__, {:unregister_name, name})
  end

  # reads are concurrent and they happen in the client processes
  def whereis_name(key) do
    case :ets.lookup(@ets_table, key) do
      [] -> :undefined
      [{^key, pid}] -> pid
    end
  end

  def send(key, message) do
    case :ets.lookup(@ets_table, key) do
      [] ->
        IO.puts("No process under the name #{inspect key}")
      [{^key, pid}] ->
        Kernel.send(pid, message)
    end
  end

  # Implementation

  def init(_) do
    :ets.new(@ets_table, [:set, :named_table])
    {:ok, %{}}
  end

  def handle_call({:register_name, key, pid}, _, state) do
    case :ets.lookup(@ets_table, key) do
      [] ->
        :ets.insert(@ets_table, {key, pid})
        # monitor the process and be notified when it terminates
        Process.monitor(pid)
        {:reply, :yes, state}
      _ ->
        {:reply, :no, state}
    end
  end

  def handle_call({:unregister_name, key}, _, state) do
    :ets.delete(@ets_table, key)
    {:reply, :ok, state}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    deregister_pid(pid)
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp deregister_pid(pid) do
    :ets.match_delete(@ets_table, {:_, pid})
  end
end
