# This models a process to manage a single TodoList. It uses the TodoList data
# type.
defmodule Todo.Server do
  use GenServer

  # Public API

  def start_link(name) do
    IO.puts "Starting Todo.Server for #{name}"
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def whereis(name) do
    :gproc.whereis_name({:n, :l, {:todo_server, name}})
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

  def clear(pid) do
    GenServer.call(pid, {:clear})
  end

  # Server implementation

  def init(name) do
    # init can be heavy, use this technique to make "process creation" faster
    # by delaying real init
    send(self, :real_init)
    {:ok, {name, nil}}
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    todo_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, todo_list)
    {:noreply, {name, todo_list}}
  end

  def handle_cast({:update_entry, new_entry}, {name, todo_list}) do
    todo_list = Todo.List.update_entry(todo_list, new_entry)
    Todo.Database.store(name, todo_list)
    {:noreply, {name, todo_list}}
  end

  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    todo_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, todo_list)
    {:noreply, {name, todo_list}}
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end

  def handle_call({:clear}, _, {name, _todo_list}) do
    Todo.Database.clear(name)
    {:reply, :ok, {name, Todo.List.new}}
  end

  def handle_info(:real_init, {name, nil}) do
    {:noreply, {name, Todo.Database.get(name) || Todo.List.new}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {:todo_server, name}}}
  end
end
