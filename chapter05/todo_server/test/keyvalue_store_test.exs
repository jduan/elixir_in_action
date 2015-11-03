defmodule KeyvalueStoreTest do
  use ExUnit.Case
  doctest KeyvalueStore

  test "put" do
    store = KeyvalueStore.new

    KeyvalueStore.put(store, "name", "jingjing")

    assert KeyvalueStore.get(store, "name") == "jingjing"
  end
end
