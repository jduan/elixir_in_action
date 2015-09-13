defmodule TodoListTest do
  use ExUnit.Case

  test "test todo list" do
    todo_list = TodoList.new
    |> TodoList.add_entry({2013, 12, 19}, "Dentist")
    |> TodoList.add_entry({2013, 12, 20}, "Shopping")
    |> TodoList.add_entry({2013, 12, 19}, "Movies")

    assert TodoList.entries(todo_list, {2013, 12, 19}) == ["Movies", "Dentist"]
    assert TodoList.entries(todo_list, {2013, 12, 20}) == ["Shopping"]
    assert TodoList.entries(todo_list, {2013, 12, 21}) == nil
  end
end
