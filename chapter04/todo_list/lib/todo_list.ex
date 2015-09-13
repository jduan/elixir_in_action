defmodule TodoList do
  def new do
    %{}
  end

  def add_entry(todo, key, what) do
    Map.update(todo, key, [what],
      fn lst -> [what | lst] end)
  end

  def entries(todo, key) do
    Map.get(todo, key, [])
  end
end
