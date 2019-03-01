defmodule Test.CounterSupervisor do
  use ExUnit.Case

  test "find_or_create_process" do
    {:ok, counter} = ExCounter.CounterSupervisor.find_or_create_process(:counter_one)
    assert counter == :counter_one
  end

  test "increment a counter by default value" do
    {:ok, counter} = ExCounter.CounterSupervisor.find_or_create_process(:counter_one)
    ExCounter.Counter.increment(counter)
    assert ExCounter.Counter.value(counter) == 1
  end

  test "increment a counter by 3" do
    {:ok, counter} = ExCounter.CounterSupervisor.find_or_create_process(:counter_two)
    ExCounter.Counter.increment(counter, 3)
    assert ExCounter.Counter.value(counter) == 3
  end

  test "spins up multiple processes" do
    for value <- 0..30 do
      ExCounter.increment(:"counter_#{value}")
    end

    # `>=` is a cheat for not tearing down the previous started
    # processes in this test suite
    assert ExCounter.CounterSupervisor.process_count() >= 31
  end
end
