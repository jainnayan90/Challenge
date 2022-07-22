defmodule Challenge.WalletSupervisor do
  @moduledoc """
  This supervisor is responsible to create wallet for the users.
  """
  use DynamicSupervisor

  alias Challenge.Models.User
  alias Challenge.WalletWorker

  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_children(List.t()) :: :ok
  def start_children(users) do
    for user <- users do
      user
      |> get_child_specs()
      |> start_child_process()
    end
    :ok
  end

  defp get_child_specs(user), do: {WalletWorker, User.new(%{id: user})}

  defp start_child_process({_, %User{}} = child_spec), do: DynamicSupervisor.start_child(__MODULE__, child_spec)
  defp start_child_process(_), do: :ok
end
