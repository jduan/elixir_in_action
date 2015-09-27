defmodule TodoList2Test do
  use ExUnit.Case

  test "test TodoList2" do
    todo_list = TodoList2.new
    |> TodoList2.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
    |> TodoList2.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
    |> TodoList2.add_entry(%{date: {2013, 12, 19}, title: "Movies"})

    assert TodoList2.entries(todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Dentist"},
    ]
    assert TodoList2.entries(todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
    assert TodoList2.entries(todo_list, {2013, 12, 21}) == []
  end
end
