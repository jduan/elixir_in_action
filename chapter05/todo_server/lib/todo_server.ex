defmodule TodoServer do
  @alias __MODULE__

  def start do
    pid = spawn(fn -> loop(TodoList2.new) end)
    Process.register(pid, @alias)
  end

  def add_entry(new_entry) do
    send(@alias, {:add_entry, new_entry})
  end

  def update_entry(new_entry) do
    send(@alias, {:update_entry, new_entry})
  end

  def delete_entry(entry_id) do
    send(@alias, {:delete_entry, entry_id})
  end

  def entries(date) do
    send(@alias, {:entries, self, date})
    receive do
      {:entries, entries} -> entries
    end
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      message ->
        process_message(todo_list, message)
    end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList2.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:update_entry, new_entry}) do
    TodoList2.update_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:delete_entry, entry_id}) do
    TodoList2.delete_entry(todo_list, entry_id)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:entries, TodoList2.entries(todo_list, date) })
    todo_list
  end
end
