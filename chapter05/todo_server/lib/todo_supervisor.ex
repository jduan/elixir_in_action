defmodule TodoSupervisor do
  use Supervisor

  # Public API
  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  # Implementation

  # Returns the "supervision specs"
  def init(_) do
    processes = [worker(TodoCache, [])]
    supervise(processes, strategy: :one_for_one)
  end
end
