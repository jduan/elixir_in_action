defmodule MultiDict do
  def new do
    %{}
  end

  def put(dict, key, value) do
    Map.update(dict, key, [value],
    fn lst -> [value | lst] end)
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end
