defmodule TodoServer do
  use GenServer

  # public API
  def start do
    {:ok, pid} = GenServer.start(__MODULE__, nil)
    pid
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def update_entry(pid, new_entry) do
    GenServer.cast(pid, {:update_entry, new_entry})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete_entry, entry_id})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # implementation detail
  def init(_) do
    {:ok, TodoList.new}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:update_entry, new_entry}, todo_list) do
    {:noreply, TodoList.update_entry(todo_list, new_entry)}
  end

  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, TodoList.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end

  def handle_info(_, todo_list) do
    {:noreply, todo_list}
  end
end
