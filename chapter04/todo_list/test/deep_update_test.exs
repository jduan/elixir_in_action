defmodule DeepUpdateTest do
  use ExUnit.Case

  test "immutable hierarchical updates" do
    todo_list = [
      {1, %{date: {2013, 12, 19}, title: "Dentist"}},
      {2, %{date: {2013, 12, 20}, title: "Shopping"}},
      {3, %{date: {2013, 12, 19}, title: "Movies"}},
    ] |> Enum.into(HashDict.new)

    todo_list2 = [
      {1, %{date: {2013, 12, 19}, title: "Dentist2"}},
      {2, %{date: {2013, 12, 20}, title: "Shopping"}},
      {3, %{date: {2013, 12, 19}, title: "Movies"}},
    ] |> Enum.into(HashDict.new)

    # put_in
    assert put_in(todo_list[1][:title], "Dentist2") == todo_list2
    assert put_in(todo_list, [1, :title], "Dentist2") == todo_list2

    # get_in
    assert get_in(todo_list, [1, :title]) == "Dentist"
    assert get_in(todo_list, [1, :date]) == {2013, 12, 19}
    assert get_in(todo_list, [2, :date]) == {2013, 12, 20}
  end
end
