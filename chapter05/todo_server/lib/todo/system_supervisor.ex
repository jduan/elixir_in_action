defmodule Todo.SystemSupervisor do
  use Supervisor

  # Public API
  def start_link do
    IO.puts "Starting Todo.SystemSupervisor"
    Supervisor.start_link(__MODULE__, nil)
  end

  # Implementation

  # Returns the "supervision specs"
  def init(_) do
    processes = [
      # worker: by default the function start_link is called on the module
      supervisor(Todo.Database, ["./persist"]),
      supervisor(Todo.ServerSupervisor, []),
      worker(Todo.Cache, []),
    ]
    supervise(processes, strategy: :one_for_one)
  end
end
