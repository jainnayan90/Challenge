defmodule Challenge.Operator do
  @moduledoc """
  This module implements the operator actions for the games.
  """

  @registry Challenge.Registry

  alias Challenge.WalletSupervisor

  @doc """
  Start a linked and isolated supervision tree and returns the root server that
  will handle the requests.
  """

  @spec start :: GenServer.server()
  def start() do
    {:ok, pid} = WalletSupervisor.start_link()
    pid
  end

  @doc """
  Create non-existing users with currency as "USD" and amount as 100_000.

  It ignores any entry that is NOT a non-empty binary or if the user already exists.
  """

  @spec create_users(server :: GenServer.server(), users :: [String.t()]) :: :ok
  def create_users(server, users), do: WalletSupervisor.start_children(server, users)

  @doc """
  This function places bet for a user.
  The `body` parameter is a map with keys as atoms.
  The result is a map with keys as atoms.
  """
  @spec bet(server :: GenServer.server(), body :: map) :: map
  def bet(server, body), do: WalletSupervisor.bet(server, body, @registry)

  @doc """
    This function processes win request made against a bet.
    The `body` parameter a map with keys as atoms.
    The result is a map with keys as atoms.
  """
  @spec win(server :: GenServer.server(), body :: map) :: map
  def win(server, body), do: WalletSupervisor.win(server, body, @registry)
end
