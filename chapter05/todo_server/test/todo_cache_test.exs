defmodule TodoCacheTest do
  use ExUnit.Case
  doctest TodoCache

  test "same name should map to the same process" do
    TodoCache.start
    pid1 = TodoCache.server_process("todo1")
    pid2 = TodoCache.server_process("todo1")

    assert pid1 == pid2
    assert TodoServer.entries(pid1, %{date: {2013, 12, 10}}) == []

    TodoServer.add_entry(pid1, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid1, %{date: {2013, 12, 10}, title: "Shopping"})
    assert TodoServer.entries(pid1, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end

  test "test a single process" do
    TodoCache.start
    pid2 = TodoCache.server_process("todo2")

    assert TodoServer.entries(pid2, %{date: {2013, 12, 10}}) == []

    TodoServer.add_entry(pid2, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid2, %{date: {2013, 12, 10}, title: "Shopping"})
    assert TodoServer.entries(pid2, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
