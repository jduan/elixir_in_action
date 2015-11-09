defmodule TodoDatabaseTest do
  use ExUnit.Case
  doctest TodoDatabase

  setup do
    path = "/tmp/todolists"
    File.rm_rf!(path)
    TodoDatabase.start_link(path)
    :ok
  end

  test "get and store should work" do
    TodoDatabase.store("key1", "data1")

    assert TodoDatabase.get("key1") == "data1"
  end
end
