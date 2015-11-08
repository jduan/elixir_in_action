defmodule TodoDatabaseTest do
  use ExUnit.Case
  doctest TodoDatabase

  test "get and store should work" do
    TodoDatabase.start("/tmp")
    TodoDatabase.store("key1", "data1")

    assert TodoDatabase.get("key1") == "data1"
  end
end
