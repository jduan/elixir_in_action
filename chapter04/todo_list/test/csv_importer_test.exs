defmodule CsvImporterTest do
  use ExUnit.Case

  test "import" do
    {:ok, cwd} = File.cwd
    todo_list = CsvImporter.import("#{cwd}/test/entries.csv")

    assert TodoList2.entries(todo_list, {2013, 12, 19}) == [
      %{date: {2013, 12, 19}, title: "Movies"},
      %{date: {2013, 12, 19}, title: "Dentist"},
    ]
    assert TodoList2.entries(todo_list, {2013, 12, 20}) == [
      %{date: {2013, 12, 20}, title: "Shopping"},
    ]
  end
end
