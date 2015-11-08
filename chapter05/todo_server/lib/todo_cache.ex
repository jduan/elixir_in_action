defmodule TodoCache do
  use GenServer
  @alias __MODULE__

  def start do
    GenServer.start(__MODULE__, nil, name: @alias)
  end

  def server_process(name) do
    GenServer.call(@alias, {:server_process, name})
  end

  # Stop all the TodoServers
  def clear do
    GenServer.call(@alias, {:clear})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:server_process, name}, _, cache) do
    case Map.fetch(cache, name) do
      {:ok, pid} ->
        {:reply, pid, cache}
      :error ->
        pid = TodoServer.start
        {:reply, pid, Map.put(cache, name, pid)}
    end
  end

  def handle_call({:clear}, _, cache) do
    cache
    |> Enum.each(fn {_name, pid} ->
      Process.exit(pid, :kill)
    end)

    {:reply, :ok, %{}}
  end
end
