defmodule KeyvalueStoreTest do
  use ExUnit.Case
  doctest KeyvalueStore

  test "put" do
    store = KeyvalueStore.new

    KeyvalueStore.put(store, "name", "jingjing")
    KeyvalueStore.put(store, "sex", "male")

    assert KeyvalueStore.get(store, "name") == "jingjing"
    assert KeyvalueStore.get(store, "sex") == "male"
    assert KeyvalueStore.size(store) == 2

    KeyvalueStore.delete(store, "sex")
    assert KeyvalueStore.get(store, "sex") == nil
    assert KeyvalueStore.size(store) == 1
  end
end
