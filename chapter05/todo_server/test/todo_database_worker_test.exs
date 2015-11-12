defmodule TodoDatabaseWorkerTest do
  use ExUnit.Case
  doctest TodoDatabaseWorker

  setup do
    path = "/tmp/todolists"
    pid = TodoDatabaseWorker.start_link(path)
    {:ok, pid: pid}
  end

  test "get and store should work", context do
    pid = context[:pid]
    TodoDatabaseWorker.store(pid, "key1", "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert TodoDatabaseWorker.get(pid, "key1") == "data1"

    TodoDatabaseWorker.clear(pid, "key1")
  end
end
