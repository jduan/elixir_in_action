defmodule Todo.ProcessRegistry do
  use GenServer

  # Public API

  def start_link do
    IO.puts "Starting Todo.ProcessRegistry"
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register_name(name, pid) do
    GenServer.call(__MODULE__, {:register_name, name, pid})
  end

  def unregister_name(name) do
    GenServer.call(__MODULE__, {:unregister_name, name})
  end

  def whereis_name(name) do
    GenServer.call(__MODULE__, {:whereis_name, name})
  end

  def send(name, message) do
    GenServer.call(__MODULE__, {:send, name, message})
  end

  # Implementation

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:register_name, key, pid}, _, registry) do
    case Map.get(registry, key) do
      nil ->
        # monitor the process and be notified when it terminates
        Process.monitor(pid)
        {:reply, :yes, Map.put(registry, key, pid)}
      _ ->
        {:reply, :no, registry}
    end
  end

  def handle_call({:unregister_name, key}, _, registry) do
    {:reply, :key, Map.delete(registry, key)}
  end

  def handle_call({:whereis_name, key}, _, registry) do
    {:reply, Map.get(registry, key, :undefined), registry}
  end

  def handle_call({:send, key, message}, _, registry) do
    case Map.get(registry, key) do
      nil ->
        IO.puts("No process under the name #{inspect key}")
        {:reply, :not_ok, registry}
      pid ->
        Kernel.send(pid, message)
        {:reply, :ok, registry}
    end
  end

  def handle_info({:DOWN, _, :process, pid, _}, registry) do
    {:noreply, deregister_pid(registry, pid)}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp deregister_pid(registry, pid) do
    Enum.reduce(
      registry,
      registry,
      fn
        ({name, ppid}, acc) when pid == ppid ->
          Map.delete(acc, name)
        (_, acc) -> acc
      end
    )
  end
end
