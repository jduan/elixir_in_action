defmodule TodoDatabaseTest do
  use ExUnit.Case
  doctest TodoDatabase

  setup do
    path = "/tmp/todolists"
    TodoDatabase.start_link(path)
    :ok
  end

  test "get and store should work" do
    TodoDatabase.store("key1", "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert TodoDatabase.get("key1") == "data1"

    TodoDatabase.clear
  end
end
