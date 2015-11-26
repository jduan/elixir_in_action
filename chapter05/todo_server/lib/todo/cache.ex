# TodoCache is used to start TodoServer based on name.
defmodule Todo.Cache do
  use GenServer
  @alias __MODULE__

  # Public API

  def start_link do
    IO.puts "Starting Todo.Cache"
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
    pid = case Todo.Server.whereis(name) do
      :undefined ->
        IO.puts "#{name} hasn't started yet"
        Todo.ServerSupervisor.start_child(name)
        Todo.Server.whereis(name)
      pid -> pid
    end
    {:reply, pid, state}
  end

end
