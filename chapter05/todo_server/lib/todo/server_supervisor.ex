defmodule Todo.ServerSupervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting Todo.ServerSupervisor"
    Supervisor.start_link(__MODULE__, nil,
      name: __MODULE__,
    )
  end

  def start_child(todo_list_name) do
    Supervisor.start_child(
      __MODULE__,
      [todo_list_name]
    )
  end

  def init(_) do
    supervise(
      [
        worker(Todo.Server, [])
      ],
      strategy: :simple_one_for_one
    )
  end
end
