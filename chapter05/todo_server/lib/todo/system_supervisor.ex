defmodule Todo.SystemSupervisor do
  use Supervisor

  @moduledoc """
  This is the Todo.SystemSupervisor module.

  For more info, see the `Todo.PoolSupervisor` module.
  """

  @doc """
  Says hello to the given `name`.

  Returns `:ok`.

  ## Examples

      iex> MyApp.Hello.world(:john)
      :ok

  """

  # Public API
  def start_link do
    IO.puts "Starting Todo.SystemSupervisor"
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
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
