# TodoCache is used to start TodoServer based on name.
defmodule TodoCache do
  use GenServer
  @alias __MODULE__

  # Public API

  def start_link do
    IO.puts "Starting TodoCache"
    GenServer.start_link(__MODULE__, nil, name: @alias)
  end

  def server_process(name) do
    GenServer.call(@alias, {:server_process, name})
  end

  # Server implementation

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, name}, _, state) do
    pid = case TodoServer.whereis(name) do
      :undefined ->
        IO.puts "#{name} hasn't started yet"
        Todo.ServerSupervisor.start_child(name)
      pid -> pid
    end
    {:reply, pid, state}
  end

end
