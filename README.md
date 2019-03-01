# ExCounter

A library that dynamically spins up a process given a name of a counter, and keeps the count.

Optionally a config value of `lifetime_ms` can be given to kill and restart the counter. If not provided, then the process will carry on counting until it crashes.

## Usage
To increment by 1:
`ExCounter.increment(:web_responses_500)`
or to increment by multiple
`ExCounter.increment(:web_responses_500, 4)`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_counter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_counter, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_counter](https://hexdocs.pm/ex_counter).

