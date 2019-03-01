defmodule ExCounter do
  def increment(counter_name, value \\ 1) do
    {:ok, counter} = ExCounter.CounterSupervisor.find_or_create_process(counter_name)
    ExCounter.Counter.increment(counter, value)
  end
end
