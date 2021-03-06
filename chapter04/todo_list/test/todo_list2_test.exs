defmodule TodoList2Test do
  use ExUnit.Case

  setup do
    todo_list = TodoList2.new
    |> TodoList2.add_entry(%{date: {2013, 12, 19}, title: "Dentist"})
    |> TodoList2.add_entry(%{date: {2013, 12, 20}, title: "Shopping"})
    |> TodoList2.add_entry(%{date: {2013, 12, 19}, title: "Movies"})

    {:ok, todo_list: todo_list}
  end

  test "test TodoList2", context do
    todo_list = context[:todo_list]
    assert TodoList2.entries(todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Dentist"},
    ]
    assert TodoList2.entries(todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
    assert TodoList2.entries(todo_list, {2013, 12, 21}) == []
  end

  test "update", context do
    todo_list = context[:todo_list]
    new_todo_list = TodoList2.update_entry(todo_list, 1, fn entry ->
      %{entry | title: "Study"}
    end)
    assert TodoList2.entries(new_todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Study"},
    ]
    assert TodoList2.entries(new_todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
  end

  test "update2", context do
    todo_list = context[:todo_list]
    new_todo_list = TodoList2.update_entry(todo_list,
      %{id: 1, date: {2013, 12, 91}, title: "Dentist"}
    )
    assert TodoList2.entries(new_todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
    ]
    assert TodoList2.entries(new_todo_list, {2013, 12, 91}) == [
      %{date: {2013, 12, 91}, title: "Dentist"},
    ]
    assert TodoList2.entries(new_todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
  end

  test "delete", context do
    todo_list = context[:todo_list]
    new_todo_list = TodoList2.delete_entry(todo_list, 1)
    assert TodoList2.entries(new_todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
    ]
    assert TodoList2.entries(new_todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
  end

  test "iterative updates" do
    entries = [
      %{date: {2013, 12, 19}, title: "Dentist"},
      %{date: {2013, 12, 20}, title: "Shopping"},
      %{date: {2013, 12, 19}, title: "Movies"},
    ]
    todo_list = TodoList2.new(entries)

    assert TodoList2.entries(todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Dentist"},
    ]
    assert TodoList2.entries(todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
  end
end
