defmodule TodoServer do
  @alias __MODULE__

  # public API
  def start do
    pid = ServerProcess.start(TodoServer)
    Process.register(pid, @alias)
  end

  def add_entry(new_entry) do
    ServerProcess.cast(@alias, {:add_entry, new_entry})
  end

  def update_entry(new_entry) do
    ServerProcess.cast(@alias, {:update_entry, new_entry})
  end

  def delete_entry(entry_id) do
    ServerProcess.cast(@alias, {:delete_entry, entry_id})
  end

  def entries(date) do
    ServerProcess.call(@alias, {:entries, date})
  end

  # implementation detail
  def init do
    TodoList.new
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList.add_entry(todo_list, new_entry)
  end

  def handle_cast({:update_entry, new_entry}, todo_list) do
    TodoList.update_entry(todo_list, new_entry)
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    TodoList.delete_entry(todo_list, entry_id)
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList.entries(todo_list, date), todo_list}
  end
end
