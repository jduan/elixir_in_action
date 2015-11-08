defmodule TodoServer do
  use GenServer

  # public API
  def start(name) do
    {:ok, pid} = GenServer.start(__MODULE__, name)
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
  def init(name) do
    todo_list = case TodoDatabase.get(name) do
      nil -> TodoList.new
      lst -> lst
    end
    {:ok, {name, todo_list}}
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    todo_list = TodoList.add_entry(todo_list, new_entry)
    TodoDatabase.store(name, todo_list)
    {:noreply, {name, todo_list}}
  end

  def handle_cast({:update_entry, new_entry}, {name, todo_list}) do
    todo_list = TodoList.update_entry(todo_list, new_entry)
    TodoDatabase.store(name, todo_list)
    {:noreply, {name, todo_list}}
  end

  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    todo_list = TodoList.delete_entry(todo_list, entry_id)
    TodoDatabase.store(name, todo_list)
    {:noreply, {name, todo_list}}
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, TodoList.entries(todo_list, date), {name, todo_list}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
