defmodule CsvImporter do
  def import(file) do
    file
    |> File.stream!
    |> Stream.map(fn line ->
      [date, title] = line
        |> String.rstrip
        |> String.split(",")

      date_tuple = date
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple

      %{date: date_tuple, title: title}
    end)
    |> TodoList2.new
  end
end
