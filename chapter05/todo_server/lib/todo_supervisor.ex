defmodule TodoSupervisor do
  use Supervisor

  # Public API
  def start_link do
    IO.puts "Starting TodoSupervisor"
    Supervisor.start_link(__MODULE__, nil)
  end

  # Implementation

  # Returns the "supervision specs"
  def init(_) do
    processes = [
      # worker: by default the function start_link is called on the module
      worker(TodoCache, []),
      worker(TodoDatabase, ["./persist"]),
    ]
    supervise(processes, strategy: :one_for_one)
  end
end
