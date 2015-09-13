defmodule Concurrency do
  def run_query(query_def) do
    :timer.sleep(2000)
    "#{query_def} result"
  end
end

async_query = fn query_def ->
  caller = self
  spawn fn ->
    send(caller, {:query_result, Concurrency.run_query(query_def)})
  end
end

1..5 |> Enum.each &async_query.("query #{&1}")

get_result = fn ->
  receive do
    {:query_result, result} -> IO.puts result
  end
end

results = 1..5 |> Enum.map(fn _ -> get_result.() end)

defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self, query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after 5000 ->
      {:error, :timeout}
    end
  end

  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    end

    loop
  end

  defp run_query(query_def) do
    :timer.sleep(2000)
    "#{query_def} result"
  end
end

defmodule Calculator do
  def start do
    spawn(fn -> loop 0 end)
  end

  def value(pid) do
    send(pid, {:value, self})
    receive do
      {:value, value} -> value
    end
  end

  def add(pid, amount), do: send(pid, {:add, amount})
  def sub(pid, amount), do: send(pid, {:sub, amount})
  def mul(pid, amount), do: send(pid, {:mul, amount})
  def div(pid, amount), do: send(pid, {:div, amount})

  defp loop(current_value) do
    new_value = receive do
      message ->
        process_message(current_value, message)
    end

    loop(new_value)
  end

  defp process_message(current_value, {:value, caller}) do
    send(caller, {:value, current_value})
    current_value
  end

  defp process_message(current_value, {:add, value}) do
    current_value + value
  end

  defp process_message(current_value, {:sub, value}) do
    current_value - value
  end

  defp process_message(current_value, {:mul, value}) do
    current_value * value
  end

  defp process_message(current_value, {:div, value}) do
    current_value / value
  end
end

defmodule TodoServer do
  def start do
    pid = spawn(fn -> loop(TodoList.new) end)
    Process.register pid, __MODULE__
  end

  def add_entry(new_entry) do
    send(__MODULE__, {:add_entry, new_entry})
  end

  def entries(date) do
    send(__MODULE__, {:entries, self, date})
    receive do
      {:todo_entries, entries} -> entries
    after 5000 ->
      {:error, :timeout}
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
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end
end
