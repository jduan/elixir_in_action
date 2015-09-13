defmodule TodoList do
  def new do
    %{}
  end

  def add_entry(todo, key, what) do
    case Map.get(todo, key) do
      nil -> Map.put(todo, key, [what])
      lst -> Map.put(todo, key, [what | lst])
    end
  end

  def entries(todo, key) do
    Map.get(todo, key)
  end
end
