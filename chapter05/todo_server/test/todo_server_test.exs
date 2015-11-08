defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer

  test "add_entry" do
    path = "/tmp/todolists"
    File.rm_rf!(path)
    TodoDatabase.start(path)
    pid = TodoServer.start("server1")
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Shopping"})

    assert TodoServer.entries(pid, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
