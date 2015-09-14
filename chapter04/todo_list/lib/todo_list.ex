defmodule TodoList do
  def new do
    MultiDict.new
  end

  def add_entry(todo, entry) do
    MultiDict.put(todo, entry.date, entry)
  end

  def entries(todo, key) do
    MultiDict.get(todo, key)
  end
end
