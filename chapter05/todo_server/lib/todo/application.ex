defmodule Todo.Application do
  use Application

  def start(_type, _args) do
    response = Todo.Supervisor.start_link
    Todo.Web.start_server
    response
  end

  def stop(state) do
    IO.puts "Todo.Application is shutting down!"
  end
end
