defmodule TodoCacheTest do
  use ExUnit.Case
  doctest TodoCache
  @path "/tmp/todolists"

  setup do
    Todo.ServerSupervisor.start_link
    Todo.ProcessRegistry.start_link
    TodoCache.start_link
    TodoDatabase.start_link(@path)
    :ok
  end

  test "same name should map to the same process" do
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

    File.rm_rf!(@path)
  end

  test "test a single process" do
    pid1 = TodoCache.server_process("todo1")

    assert TodoServer.entries(pid1, %{date: {2013, 12, 10}}) == []

    TodoServer.add_entry(pid1, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid1, %{date: {2013, 12, 10}, title: "Shopping"})
    assert TodoServer.entries(pid1, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]

    File.rm_rf!(@path)
  end
end
