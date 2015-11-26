defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer
  @path "/tmp/todolists"

  setup do
    Todo.ProcessRegistry.start_link
    TodoDatabase.start_link(@path)
    :ok
  end

  test "add_entry" do
    TodoServer.start_link("server1")
    pid = TodoServer.whereis("server1")
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Shopping"})

    assert TodoServer.entries(pid, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]

    File.rm_rf!(@path)
  end
end
