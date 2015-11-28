defmodule Todo.DatabaseTest do
  use ExUnit.Case
  doctest Todo.Database
  @path "/tmp/todolists"

  test "get and store should work" do
    lst = "key1"
    Todo.Database.clear(lst)
    Todo.Database.store(lst, "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert Todo.Database.get(lst) == "data1"
  end
end
