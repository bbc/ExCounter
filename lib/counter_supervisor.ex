defmodule ExCounter.CounterSupervisor do
  use Supervisor
  require Logger

  @counter_registry_name :counter_process_registry

  def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  def find_or_create_process(counter_name) when is_atom(counter_name) do
    if counter_process_exists?(counter_name) do
      {:ok, counter_name}
    else
      counter_name
      |> create_counter_process
    end
  end

  defp create_counter_process(counter_name) when is_atom(counter_name) do
    case Supervisor.start_child(__MODULE__, [counter_name]) do
      {:ok, _pid} -> {:ok, counter_name}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end

  defp counter_process_exists?(counter_name) when is_atom(counter_name) do
    case Registry.lookup(@counter_registry_name, counter_name) do
      [] -> false
      _ -> true
    end
  end

  def stop() do
    Supervisor.stop(__MODULE__)
  end

  def process_count, do: Supervisor.which_children(__MODULE__) |> length

  def list_counters do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, counter_proc_pid, _, _} ->
      Registry.keys(@counter_registry_name, counter_proc_pid)
      |> List.first()
    end)
    |> Enum.sort()
  end

  def init(_) do
    children = [
      worker(ExCounter.Counter, [], restart: :temporary)
    ]

    # strategy set to `:simple_one_for_one` to handle dynamic child processes.
    supervise(children, strategy: :simple_one_for_one)
  end
end
