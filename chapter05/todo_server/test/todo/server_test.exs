defmodule Todo.ServerTest do
  use ExUnit.Case
  doctest Todo.Server
  @path "/tmp/todolists"

  setup do
    Todo.ProcessRegistry.start_link
    Todo.Database.start_link(@path)
    :ok
  end

  test "add_entry" do
    Todo.Server.start_link("server1")
    pid = Todo.Server.whereis("server1")
    Todo.Server.add_entry(pid, %{date: {2013, 12, 10}, title: "Movies"})
    Todo.Server.add_entry(pid, %{date: {2013, 12, 10}, title: "Shopping"})

    assert Todo.Server.entries(pid, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]

    File.rm_rf!(@path)
  end
end
