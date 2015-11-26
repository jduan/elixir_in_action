defmodule Todo.ProcessRegistry.Test do
  use ExUnit.Case
  doctest Todo.ProcessRegistry

  test "register a process and retrieve it" do
    Todo.ProcessRegistry.start_link
    Todo.ProcessRegistry.register_name({:database_worker, 1}, self)

    assert Todo.ProcessRegistry.whereis_name({:database_worker, 1}) == self
    assert Todo.ProcessRegistry.whereis_name({:database_worker, 2}) == :undefined
  end

  test "send a message" do
    Todo.ProcessRegistry.start_link
    Todo.ProcessRegistry.register_name({:database_worker, 1}, self)
    Todo.ProcessRegistry.send({:database_worker, 1}, "hello")

    receive do
      msg -> assert msg == "hello"
    end
  end
end
