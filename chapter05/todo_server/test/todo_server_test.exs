defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer

  test "add_entry" do
    server = TodoServer.start
    TodoServer.add_entry(server, %{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(server, %{date: {2013, 12, 10}, title: "Shopping"})

    assert TodoServer.entries(server, {2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
