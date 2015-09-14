defmodule TodoList do
  def new do
    MultiDict.new
  end

  def add_entry(todo, key, what) do
    MultiDict.put(todo, key, what)
  end

  def entries(todo, key) do
    MultiDict.get(todo, key)
  end
end
