defmodule Challenge.WalletWorker do
  @moduledoc """
  This module implements wallet methods to make wallet transactions.
  """
  use GenServer

  @registry :wallet_registry

  @initial_state %{user: nil, bets: %{}}

  alias Challenge.Models.Bet
  alias Challenge.Models.User

  def start_link(%User{id: id} = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(id))
  end

  @impl true
  def init(%User{} = user) do
    {:ok, %{@initial_state | user: user}}
  end

  @impl true
  def handle_call({:bet, %Bet{request_uuid: request_uuid} = bet}, _from, state) do
    with nil <- transaction_exists(bet, state),
         :ok <- check_bet_amount(bet, state),
         :ok <- check_currency(bet, state),
         {:ok, new_state} <- place_bet(bet, state) do
      response = make_bet_response(request_uuid, "RS_OK", new_state)
      {:reply, {:ok, response}, new_state}
    else
      {:error, :invalid_currency} ->
        response = make_bet_response("RS_ERROR_WRONG_CURRENCY")
        {:reply, {:ok, response}, state}

      {:error, :insufficient_funds} ->
        response = make_bet_response("RS_ERROR_NOT_ENOUGH_MONEY")
        {:reply, {:ok, response}, state}

      {:error, :duplicate_transaction} ->
        response = make_bet_response("RS_ERROR_DUPLICATE_TRANSACTION")
        {:reply, {:ok, response}, state}

      _ ->
        response = make_bet_response("RS_ERROR_UNKNOWN")
        {:reply, {:ok, response}, state}
    end
  end

  defp check_bet_amount(%Bet{amount: bet_amount}, %{user: %User{amount: amount}})
       when bet_amount < amount,
       do: :ok

  defp check_bet_amount(_, _), do: {:error, :insufficient_funds}

  defp check_currency(%Bet{currency: bet_currency}, %{user: %User{currency: currency}})
       when bet_currency == currency,
       do: :ok

  defp check_currency(_, _), do: {:error, :invalid_currency}

  defp make_bet_response(status), do: %{status: status}

  defp make_bet_response(request_uuid, status, %{user: %User{id: id, amount: amount}}) do
    %{
      user: id,
      status: status,
      request_uuid: request_uuid,
      currency: "USD",
      balance: amount
    }
  end

  defp place_bet(
         %Bet{transaction_uuid: transaction_uuid, amount: bet_amount} = bet,
         %{user: %User{amount: amount} = user, bets: bets} = state
       ) do
    balance = amount - bet_amount
    new_user = %{user | amount: balance}
    new_bets = Map.put(bets, transaction_uuid, bet)
    {:ok, %{state | user: new_user, bets: new_bets}}
  end

  defp transaction_exists(%Bet{transaction_uuid: transaction_uuid}, %{bets: bets}) do
    if bets[transaction_uuid] == nil do
      nil
    else
      {:error, :duplicate_transaction}
    end
  end

  defp transaction_exists(_, _), do: {:error, :duplicate_transaction}

  defp via_tuple(name),
    do: {:via, Registry, {@registry, name}}
end
