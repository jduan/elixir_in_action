defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer

  test "add_entry" do
    pid = TodoServer.start
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(pid, %{date: {2013, 12, 10}, title: "Shopping"})

    assert TodoServer.entries(pid, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
