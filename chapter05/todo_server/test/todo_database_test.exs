defmodule TodoDatabaseTest do
  use ExUnit.Case
  doctest TodoDatabase

  setup do
    path = "/tmp/todolists"
    File.rm_rf!(path)
    TodoDatabase.start(path)

    on_exit fn ->
      TodoDatabase.clear
      TodoDatabase.stop
    end
  end

  test "get and store should work" do
    TodoDatabase.store("key1", "data1")

    assert TodoDatabase.get("key1") == "data1"
  end
end
