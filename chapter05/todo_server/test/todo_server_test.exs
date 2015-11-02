defmodule TodoServerTest do
  use ExUnit.Case
  doctest TodoServer

  test "add_entry" do
    TodoServer.start
    TodoServer.add_entry(%{date: {2013, 12, 10}, title: "Movies"})
    TodoServer.add_entry(%{date: {2013, 12, 10}, title: "Shopping"})

    assert TodoServer.entries({2013, 12, 10}) == [
      %{date: {2013, 12, 10}, title: "Shopping"},
      %{date: {2013, 12, 10}, title: "Movies"},
    ]
  end
end
