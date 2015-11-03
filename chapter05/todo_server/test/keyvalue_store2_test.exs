defmodule KeyvalueStore2Test do
  use ExUnit.Case
  doctest KeyvalueStore2

  test "put" do
    store = KeyvalueStore2.start

    KeyvalueStore2.put(store, "name", "jingjing")
    KeyvalueStore2.put(store, "sex", "male")

    assert KeyvalueStore2.get(store, "name") == "jingjing"
    assert KeyvalueStore2.get(store, "sex") == "male"
    assert KeyvalueStore2.size(store) == 2

    KeyvalueStore2.delete(store, "sex")
    assert KeyvalueStore2.get(store, "sex") == nil
    assert KeyvalueStore2.size(store) == 1
  end
end
