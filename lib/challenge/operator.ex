defmodule Challenge.Operator do
  @moduledoc """
  This module implements the operator actions for the games.
  """

  @registry :wallet_registry

  alias Challenge.WalletSupervisor

  @doc """
  Start a linked and isolated supervision tree and returns the root server that
  will handle the requests.
  """

  @spec start :: GenServer.server()
  def start() do
    children = [
      {WalletSupervisor, []},
      {Registry, [keys: :unique, name: @registry]}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    {:ok, pid} = Supervisor.start_link(children, opts)
    pid
  end

  @doc """
  Create non-existing users with currency as "USD" and amount as 100_000.

  It ignores any entry that is NOT a non-empty binary or if the user already exists.
  """

  @spec create_users(server :: GenServer.server(), users :: [String.t()]) :: :ok
  def create_users(_server, users), do: WalletSupervisor.start_children(users)
end
