defmodule ExCounter.Counter do
  use GenServer
  require Logger

  @initial_count 0
  @counter_registry_name :counter_process_registry
  defstruct counter_name: nil,
            count: 0

  def increment(counter_name, value \\ 1) do
    GenServer.cast(via_tuple(counter_name), {:increment, value})
  end

  def value(counter_name) do
    GenServer.call(via_tuple(counter_name), :value)
  end

  def start_link(counter_name) when is_atom(counter_name) do
    GenServer.start_link(__MODULE__, [counter_name], name: via_tuple(counter_name))
  end

  defp via_tuple(counter_name), do: {:via, Registry, {@counter_registry_name, counter_name}}

  # Callbacks

  @impl GenServer
  def init([counter_name]) do
    # send(self(), :fetch_data)
    # send(self(), :set_terminate_timer)

    Logger.info("Process #{counter_name} created")
    terminate_after?()

    {:ok, %__MODULE__{counter_name: counter_name, count: @initial_count}}
  end

  defp terminate_after? do
    case counter_lifetime() do
      0 -> Logger.info("Starting process indefinitely.")
      lifetime -> terminate(lifetime)
    end
  end

  defp terminate(lifetime) do
    Process.send_after(self(), :end_process, lifetime)
  end

  @impl GenServer
  def handle_info(:end_process, state) do
    Logger.info("Terminating counter #{state.counter_name}")
    {:stop, :normal, state}
  end

  def counter_lifetime do
    Application.get_env(:ex_counter, :lifetime_ms, 0)
  end

  @impl GenServer
  def handle_cast({:increment, value}, state) do
    state = %{state | count: state.count + value}

    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:value, _from, state) do
    {:reply, state.count, state}
  end
end
