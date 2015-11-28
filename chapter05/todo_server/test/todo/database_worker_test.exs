defmodule Todo.DatabaseWorkerTest do
  use ExUnit.Case
  doctest Todo.DatabaseWorker
  @path "/tmp/todolists"

  setup do
    worker_id = 2
    {:ok, worker_id: worker_id}
  end

  test "get and store should work", context do
    worker_id = context[:worker_id]
    lst = "key1"
    Todo.DatabaseWorker.clear(worker_id, lst)
    Todo.DatabaseWorker.store(worker_id, lst, "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert Todo.DatabaseWorker.get(worker_id, lst) == "data1"
  end
end
