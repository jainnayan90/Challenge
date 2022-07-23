defmodule Challenge.Models.Bet do
  @moduledoc """
  This module creates a model for bet request.
  """

  @enforce_keys [
    :user,
    :transaction_uuid,
    :supplier_transaction_id,
    :token,
    :supplier_user,
    :round_closed,
    :round,
    :reward_uuid,
    :request_uuid,
    :is_free,
    :is_aggregated,
    :game_code,
    :currency,
    :bet,
    :amount,
    :meta
  ]

  defstruct [
    :user,
    :transaction_uuid,
    :supplier_transaction_id,
    :token,
    :supplier_user,
    :round_closed,
    :round,
    :reward_uuid,
    :request_uuid,
    :is_free,
    :is_aggregated,
    :game_code,
    :currency,
    :bet,
    :amount,
    :meta
  ]

  @type t :: %__MODULE__{
          user: String.t(),
          transaction_uuid: String.t(),
          supplier_transaction_id: String.t(),
          token: String.t(),
          supplier_user: String.t(),
          round_closed: Boolean.t(),
          round: String.t(),
          reward_uuid: String.t(),
          request_uuid: String.t(),
          is_free: Boolean.t(),
          is_aggregated: Boolean.t(),
          game_code: String.t(),
          currency: String.t(),
          bet: String.t(),
          amount: Decimal.t(),
          meta: map()
        }

  @spec new(%{
          user: String.t(),
          transaction_uuid: String.t(),
          supplier_transaction_id: String.t(),
          token: String.t(),
          supplier_user: String.t(),
          round_closed: Boolean.t(),
          round: String.t(),
          reward_uuid: String.t(),
          request_uuid: String.t(),
          is_free: Boolean.t(),
          is_aggregated: Boolean.t(),
          game_code: String.t(),
          currency: String.t(),
          bet: String.t(),
          amount: Decimal.t(),
          meta: map()
        }) :: Challenge.Models.Bet.t() | {:error, atom()}
  def new(%{
        user: user_id,
        transaction_uuid: transaction_uuid,
        supplier_transaction_id: supplier_transaction_id,
        token: token,
        supplier_user: supplier_user,
        round_closed: round_closed,
        round: round,
        reward_uuid: reward_uuid,
        request_uuid: request_uuid,
        is_free: is_free,
        is_aggregated: is_aggregated,
        game_code: game_code,
        currency: currency,
        bet: bet,
        amount: amount,
        meta: meta
      }) do
    %__MODULE__{
      user: user_id,
      transaction_uuid: transaction_uuid,
      supplier_transaction_id: supplier_transaction_id,
      token: token,
      supplier_user: supplier_user,
      round_closed: round_closed,
      round: round,
      reward_uuid: reward_uuid,
      request_uuid: request_uuid,
      is_free: is_free,
      is_aggregated: is_aggregated,
      game_code: game_code,
      currency: currency,
      bet: bet,
      amount: amount,
      meta: meta
    }
    |> validate()
  end

  def new(_), do: {:error, :invalid_bet}

  defp validate(
         %__MODULE__{
           user: user_id,
           transaction_uuid: transaction_uuid,
           supplier_transaction_id: supplier_transaction_id,
           token: token,
           supplier_user: supplier_user,
           round_closed: round_closed,
           round: round,
           reward_uuid: reward_uuid,
           request_uuid: request_uuid,
           is_free: is_free,
           is_aggregated: is_aggregated,
           game_code: game_code,
           currency: currency,
           bet: bet,
           amount: amount,
           meta: meta
         } = res
       ) do
    with :ok <- validate_string(user_id),
         :ok <- validate_string(transaction_uuid),
         :ok <- validate_string(supplier_transaction_id),
         :ok <- validate_string(token),
         :ok <- validate_string(supplier_user),
         :ok <- validate_boolean(round_closed),
         :ok <- validate_string(round),
         :ok <- validate_string(reward_uuid),
         :ok <- validate_string(request_uuid),
         :ok <- validate_boolean(is_free),
         :ok <- validate_boolean(is_aggregated),
         :ok <- validate_string(game_code),
         :ok <- validate_string(currency),
         :ok <- validate_string(bet),
         :ok <- validate_decimal(amount),
         :ok <- validate_map(meta) do
      res
    else
      _ ->
        {:error, :wrong_type}
    end
  end

  defp validate_string(val) when is_binary(val) and byte_size(val) > 0, do: :ok
  defp validate_string(_), do: {:error, :wrong_type}

  defp validate_boolean(val) when is_boolean(val), do: :ok
  defp validate_boolean(_), do: {:error, :wrong_type}

  defp validate_decimal(val) when is_number(val) and val > 0, do: :ok
  defp validate_decimal(_), do: {:error, :wrong_type}

  defp validate_map(val) when is_map(val), do: :ok
  defp validate_map(_), do: {:error, :wrong_type}
end
