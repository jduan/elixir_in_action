defmodule Todo.DatabaseWorkerTest do
  use ExUnit.Case
  doctest Todo.DatabaseWorker
  @path "/tmp/todolists"

  setup do
    worker_id = 2
    Todo.ProcessRegistry.start_link
    Todo.DatabaseWorker.start_link(@path, worker_id)
    {:ok, worker_id: worker_id}
  end

  test "get and store should work", context do
    worker_id = context[:worker_id]
    Todo.DatabaseWorker.store(worker_id, "key1", "data1")

    # TODO: figure out how to remove this hack
    :timer.sleep(100)
    assert Todo.DatabaseWorker.get(worker_id, "key1") == "data1"

    File.rm_rf!(@path)
  end
end
