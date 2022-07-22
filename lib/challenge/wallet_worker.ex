defmodule Challenge.WalletWorker do
  @moduledoc """
  This module implements wallet methods to make wallet transactions.
  """
  use GenServer

  @registry :wallet_registry

  @initial_state %{user: nil, transactions: []}

  alias Challenge.Models.User

  def start_link(%User{id: id} = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(id))
  end

  @impl true
  def init(%User{} = user) do
    IO.inspect(["Starting process for user - ", user])
    {:ok, %{ @initial_state | user: user}}
  end

  defp via_tuple(name),
    do: {:via, Registry, {@registry, name}}
end
