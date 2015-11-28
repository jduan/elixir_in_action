defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting Todo.Supervisor"
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    processes = [
      # worker(Todo.ProcessRegistry, []),
      supervisor(Todo.SystemSupervisor, []),
    ]

    supervise(processes, strategy: :rest_for_one)
  end
end
