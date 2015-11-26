defmodule TodoDatabaseTest do
  use ExUnit.Case
  doctest TodoDatabase
  @path "/tmp/todolists"

  setup do
    Todo.ProcessRegistry.start_link
    TodoDatabase.start_link(@path)
    :ok
  end

  test "get and store should work" do
    TodoDatabase.store("key1", "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert TodoDatabase.get("key1") == "data1"

    File.rm_rf!(@path)
  end
end
