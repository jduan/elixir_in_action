defmodule ETS.Profiler do
  def run(module, times, concurrency_level \\ 1) do
    module.start_link

    {duration, :ok} = :timer.tc(fn ->
      execute_time(self, module, times, concurrency_level)
      1..concurrency_level
      |> Enum.each(fn _ ->
        receive do
          :done -> :ok
        end
      end)
    end)
    throughput = div(times * concurrency_level * 1000000, duration)
    IO.puts("#{throughput} reqs/sec")
  end

  def execute_time(caller, module, times, concurrency_level) do
    1..concurrency_level
    |> Enum.each(fn _n ->
      spawn(fn ->
        1..times
        |> Enum.each(fn _ ->
          module.cached(:index, &ETS.WebServer.index/0)
        end)

        send(caller, :done)
      end)
    end)
  end
end
