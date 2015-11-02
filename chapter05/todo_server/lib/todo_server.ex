defmodule TodoServer do
  def start do
    spawn(fn -> loop(TodoList2.new) end)
  end

  def add_entry(todo_server, new_entry) do
    send(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    send(todo_server, {:entries, self, date})
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

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:entries, TodoList2.entries(todo_list, date) })
    todo_list
  end
end
