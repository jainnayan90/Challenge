# Challenge

This project implements the following public functions:
  @doc """
  Start a linked and isolated supervision tree and returns the root server that
  will handle the requests.
  """
  @spec start :: GenServer.server()

  @doc """
  Create non-existing users with currency as "USD" and amount as 100_000.

  It ignores any entry that is NOT a non-empty binary or if the user already exists.
  """
  @spec create_users(server :: GenServer.server(), users :: [String.t()]) :: :ok

  @doc """
  This function places bet for a user.
  The `body` parameter is the "body" from the docs as a map with keys as atoms.
  The result is the "response" from the docs as a map with keys as atoms.
  """
  @spec bet(server :: GenServer.server(), body :: map) :: map

  @doc """
  This function processes win request made against a bet.
  The `body` parameter is the "body" from the docs as a map with keys as atoms.
  The result is the "response" from the docs as a map with keys as atoms.
  """
  @spec win(server :: GenServer.server(), body :: map) :: map


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `challenge` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:challenge, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/challenge>.

