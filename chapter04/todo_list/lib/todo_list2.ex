defmodule TodoList2 do
  defstruct auto_id: 1, entries: HashDict.new

  def new, do: %TodoList2{}

  def add_entry(%TodoList2{auto_id: auto_id, entries: entries}, entry) do
    entry = Map.put(entry, :id, auto_id)
    entries = HashDict.put(entries, auto_id, entry)

    %TodoList2{
      auto_id: auto_id + 1,
      entries: entries
    }
  end

  def entries(%TodoList2{entries: entries}, date) do
    entries
    |> Stream.filter(fn {_id, entry} -> entry.date == date end)
    |> Enum.map(fn {_id, entry} -> Map.delete(entry, :id) end)
  end
end
