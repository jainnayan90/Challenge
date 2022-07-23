defmodule Challenge.WalletSupervisor do
  @moduledoc """
  This supervisor is responsible to create wallet for the users.
  """
  use DynamicSupervisor

  alias Challenge.Models.Bet
  alias Challenge.Models.User
  alias Challenge.Models.Win
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

  @spec bet(server :: GenServer.server(), body :: map, registry :: atom()) :: map
  def bet(_server, body, registry) do
    with %Bet{user: user} = bet <- Bet.new(body),
         res = get_pid_from_registry(user, registry),
         {:ok, pid} <- get_pid_from_res(res),
         {:ok, res} <- GenServer.call(pid, {:bet, bet}) do
      res
    else
      {:error, :invalid_bet} ->
        %{status: "RS_ERROR_WRONG_SYNTAX"}

      {:error, :wrong_type} ->
        %{status: "RS_ERROR_WRONG_TYPES"}

      _ ->
        %{status: "RS_ERROR_UNKNOWN"}
    end
  end

  @spec win(server :: GenServer.server(), body :: map, registry :: atom()) :: map
  def win(_server, body, registry) do
    with %Win{user: user} = win <- Win.new(body),
         res = get_pid_from_registry(user, registry),
         {:ok, pid} <- get_pid_from_res(res),
         {:ok, res} <- GenServer.call(pid, {:win, win}) do
      res
    else
      {:error, :invalid_bet} ->
        %{status: "RS_ERROR_WRONG_SYNTAX"}

      {:error, :wrong_type} ->
        %{status: "RS_ERROR_WRONG_TYPES"}

      _ ->
        %{status: "RS_ERROR_UNKNOWN"}
    end
  end

  defp get_child_specs(user), do: {WalletWorker, User.new(%{id: user})}

  defp get_pid_from_res([]), do: []
  defp get_pid_from_res([{pid, nil}]), do: {:ok, pid}

  defp get_pid_from_registry(name, registry), do: Registry.lookup(registry, name)

  defp start_child_process({_, %User{}} = child_spec),
    do: DynamicSupervisor.start_child(__MODULE__, child_spec)

  defp start_child_process(_), do: :ok
end
