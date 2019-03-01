defmodule ExCounter.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Registry, [:unique, :counter_process_registry]),
      supervisor(ExCounter.CounterSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: ExCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
