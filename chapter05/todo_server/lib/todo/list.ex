defmodule Todo.List do
  defstruct auto_id: 1, entries: HashDict.new

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %Todo.List{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(%Todo.List{auto_id: auto_id, entries: entries}, entry) do
    entry = Map.put(entry, :id, auto_id)
    entries = HashDict.put(entries, auto_id, entry)

    %Todo.List{
      auto_id: auto_id + 1,
      entries: entries
    }
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn {_id, entry} -> entry.date == date end)
    |> Enum.map(fn {_id, entry} -> Map.delete(entry, :id) end)
  end

  def update_entry(
    %Todo.List{entries: entries} = todo_list,
    entry_id,
    updater_func
  ) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        new_entry = %{id: ^entry_id} = updater_func.(old_entry)
        new_entries = HashDict.put(entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(%Todo.List{entries: entries, auto_id: auto_id}, entry_id) do
    new_entries = Dict.delete(entries, entry_id)
    %Todo.List{
      auto_id: auto_id,
      entries: new_entries
    }
  end
end
