defmodule KeyvalueStoreTest do
  use ExUnit.Case
  doctest KeyvalueStore

  test "put" do
    store = ServerProcess.start(KeyvalueStore)
    ServerProcess.call(store, {:put, "name", "jingjing"})

    assert ServerProcess.call(store, {:get, "name"}) == "jingjing"
  end
end
