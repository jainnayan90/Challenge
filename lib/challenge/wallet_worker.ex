defmodule Challenge.WalletWorker do
  @moduledoc """
  This module implements wallet methods to make wallet transactions.
  """
  use GenServer

  @registry Challenge.Registry

  @initial_state %{user: nil, bets: %{}, wins: %{}, server: nil}

  alias Challenge.Models.Bet
  alias Challenge.Models.User
  alias Challenge.Models.Win

  def start_link([%User{id: id}, _server] = opts) do
    GenServer.start_link(__MODULE__, opts, name: via_tuple(id))
  end

  @impl true
  def init([%User{} = user, server]) do
    {:ok, %{@initial_state | user: user, server: server}}
  end

  @impl true
  def handle_call({:bet, %Bet{request_uuid: request_uuid} = bet}, _from, state) do
    with nil <- transaction_exists(bet.transaction_uuid, state.bets),
         :ok <- check_bet_amount(bet, state),
         :ok <- check_currency(bet.currency, state),
         {:ok, new_state} <- place_bet(bet, state) do
      response = make_success_response(request_uuid, "RS_OK", new_state)
      {:reply, {:ok, response}, new_state}
    else
      {:error, :invalid_currency} ->
        response = make_error_response("RS_ERROR_WRONG_CURRENCY")
        {:reply, {:ok, response}, state}

      {:error, :insufficient_funds} ->
        response = make_error_response("RS_ERROR_NOT_ENOUGH_MONEY")
        {:reply, {:ok, response}, state}

      {:error, :duplicate_transaction} ->
        response = make_error_response("RS_ERROR_DUPLICATE_TRANSACTION")
        {:reply, {:ok, response}, state}
    end
  end

  def handle_call({:win, %Win{request_uuid: request_uuid} = win}, _from, state) do
    with nil <- transaction_exists(win.transaction_uuid, state.wins),
         %Bet{} <- check_bet_exists(win.reference_transaction_uuid, state.bets),
         :ok <- check_currency(win.currency, state),
         {:ok, new_state} <- process_win(win, state) do
      response = make_success_response(request_uuid, "RS_OK", new_state)
      {:reply, {:ok, response}, new_state}
    else
      {:error, :no_bet_exists} ->
        response = make_error_response("RS_ERROR_TRANSACTION_DOES_NOT_EXIST")
        {:reply, {:ok, response}, state}

      {:error, :invalid_currency} ->
        response = make_error_response("RS_ERROR_WRONG_CURRENCY")
        {:reply, {:ok, response}, state}

      {:error, :duplicate_transaction} ->
        response = make_error_response("RS_ERROR_DUPLICATE_TRANSACTION")
        {:reply, {:ok, response}, state}
    end
  end

  defp check_bet_amount(%Bet{amount: bet_amount}, %{user: %User{amount: amount}})
       when bet_amount < amount,
       do: :ok

  defp check_bet_amount(_, _), do: {:error, :insufficient_funds}

  defp check_bet_exists(transaction_uuid, bets) do
    if bets[transaction_uuid] == nil do
      {:error, :no_bet_exists}
    else
      bets[transaction_uuid]
    end
  end

  defp check_currency(transaction_currency, %{user: %User{currency: currency}})
       when transaction_currency == currency,
       do: :ok

  defp check_currency(_, _), do: {:error, :invalid_currency}

  defp make_error_response(status), do: %{status: status}

  defp make_success_response(request_uuid, status, %{
         user: %User{id: id, amount: amount, currency: currency}
       }) do
    %{
      user: id,
      status: status,
      request_uuid: request_uuid,
      currency: currency,
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

  defp process_win(
         %Win{transaction_uuid: transaction_uuid, amount: win_amount} = win,
         %{user: %User{amount: amount} = user, wins: wins} = state
       ) do
    balance = amount + win_amount
    new_user = %{user | amount: balance}
    new_wins = Map.put(wins, transaction_uuid, win)
    {:ok, %{state | user: new_user, wins: new_wins}}
  end

  defp transaction_exists(transaction_uuid, transactions) do
    if transactions[transaction_uuid] == nil do
      nil
    else
      {:error, :duplicate_transaction}
    end
  end

  defp via_tuple(name),
    do: {:via, Registry, {@registry, name}}
end
