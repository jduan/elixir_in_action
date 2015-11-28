defmodule Todo.CacheTest do
  use ExUnit.Case
  doctest Todo.Cache

  test "same name should map to the same process" do
    pid1 = Todo.Cache.server_process("todo1")
    pid2 = Todo.Cache.server_process("todo1")

    assert pid1 == pid2
    Todo.Server.clear(pid1)
    assert Todo.Server.entries(pid1, %{date: {2013, 12, 10}}) == []

    Todo.Server.add_entry(pid1, %{date: {2013, 12, 10}, title: "Movies"})
    Todo.Server.add_entry(pid1, %{date: {2013, 12, 10}, title: "Shopping"})
    assert Todo.Server.entries(pid1, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end

  test "test a single process" do
    pid1 = Todo.Cache.server_process("todo1")

    Todo.Server.clear(pid1)
    assert Todo.Server.entries(pid1, %{date: {2013, 12, 10}}) == []

    Todo.Server.add_entry(pid1, %{date: {2013, 12, 10}, title: "Movies"})
    Todo.Server.add_entry(pid1, %{date: {2013, 12, 10}, title: "Shopping"})
    assert Todo.Server.entries(pid1, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
