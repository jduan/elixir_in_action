defmodule TodoListTest do
  use ExUnit.Case

  test "test todo list" do
    todo_list = TodoList.new
    |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
    |> TodoList.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
    |> TodoList.add_entry(%{date: {2013, 12, 19}, title: "Movies"})

    assert TodoList.entries(todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Dentist"},
    ]
    assert TodoList.entries(todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
    assert TodoList.entries(todo_list, {2013, 12, 21}) == []
  end
end
