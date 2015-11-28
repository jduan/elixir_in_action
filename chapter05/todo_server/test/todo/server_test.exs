defmodule Todo.ServerTest do
  use ExUnit.Case
  doctest Todo.Server

  test "add_entry" do
    Todo.Server.start_link("server1")
    pid = Todo.Server.whereis("server1")
    Todo.Server.clear(pid)
    Todo.Server.add_entry(pid, %{date: {2013, 12, 10}, title: "Movies"})
    Todo.Server.add_entry(pid, %{date: {2013, 12, 10}, title: "Shopping"})

    assert Todo.Server.entries(pid, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
