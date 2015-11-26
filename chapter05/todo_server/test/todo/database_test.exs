defmodule Todo.DatabaseTest do
  use ExUnit.Case
  doctest Todo.Database
  @path "/tmp/todolists"

  setup do
    Todo.ProcessRegistry.start_link
    Todo.Database.start_link(@path)
    :ok
  end

  test "get and store should work" do
    Todo.Database.store("key1", "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert Todo.Database.get("key1") == "data1"

    File.rm_rf!(@path)
  end
end
