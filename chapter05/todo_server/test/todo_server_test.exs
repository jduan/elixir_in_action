defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer

  setup do
    path = "/tmp/todolists"
    File.rm_rf!(path)
    TodoDatabase.start_link(path)
    :ok
  end

  test "add_entry" do
    pid = TodoServer.start_link("server1")
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Shopping"})

    assert TodoServer.entries(pid, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
