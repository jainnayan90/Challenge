defmodule Challenge.Models.Win do
  @moduledoc """
  This module creates a model for win request.
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
    :reference_transaction_uuid,
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
    :reference_transaction_uuid,
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
          reference_transaction_uuid: String.t(),
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
          reference_transaction_uuid: String.t(),
          is_free: Boolean.t(),
          is_aggregated: Boolean.t(),
          game_code: String.t(),
          currency: String.t(),
          bet: String.t(),
          amount: Decimal.t(),
          meta: map()
        }) :: Challenge.Models.Win.t() | {:error, atom()}
  def new(
        %{
          user: user_id,
          transaction_uuid: transaction_uuid,
          supplier_transaction_id: supplier_transaction_id,
          token: token,
          reward_uuid: reward_uuid,
          request_uuid: request_uuid,
          reference_transaction_uuid: reference_transaction_uuid,
          game_code: game_code,
          currency: currency,
          amount: amount
        } = res
      ) do
    %__MODULE__{
      user: user_id,
      transaction_uuid: transaction_uuid,
      supplier_transaction_id: supplier_transaction_id,
      token: token,
      supplier_user: Map.get(res, :supplier_user),
      round_closed: Map.get(res, :round_closed),
      round: Map.get(res, :round),
      reward_uuid: reward_uuid,
      request_uuid: request_uuid,
      reference_transaction_uuid: reference_transaction_uuid,
      is_free: Map.get(res, :is_free),
      is_aggregated: Map.get(res, :is_aggregated),
      game_code: game_code,
      currency: currency,
      bet: Map.get(res, :bet),
      amount: amount,
      meta: Map.get(res, :meta)
    }
    |> validate()
  end

  def new(_), do: {:error, :invalid_win}

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
           reference_transaction_uuid: reference_transaction_uuid,
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
         :ok <- validate_token(token),
         :ok <- validate_nullable_string(supplier_user),
         :ok <- validate_nullable_boolean(round_closed),
         :ok <- validate_nullable_string(round),
         :ok <- validate_string(reward_uuid),
         :ok <- validate_string(request_uuid),
         :ok <- validate_string(reference_transaction_uuid),
         :ok <- validate_nullable_boolean(is_free),
         :ok <- validate_nullable_boolean(is_aggregated),
         :ok <- validate_string(game_code),
         :ok <- validate_string(currency),
         :ok <- validate_nullable_string(bet),
         :ok <- validate_decimal(amount),
         :ok <- validate_nullable_map(meta) do
      res
    else
      _ ->
        {:error, :wrong_type}
    end
  end

  defp validate_string(val) when is_binary(val) and byte_size(val) > 0, do: :ok
  defp validate_string(_), do: {:error, :wrong_type}

  defp validate_nullable_string(nil), do: :ok
  defp validate_nullable_string(val) when is_binary(val) and byte_size(val) > 0, do: :ok
  defp validate_nullable_string(_), do: {:error, :wrong_type}

  defp validate_nullable_boolean(nil), do: :ok
  defp validate_nullable_boolean(val) when is_boolean(val), do: :ok
  defp validate_nullable_boolean(_), do: {:error, :wrong_type}

  defp validate_decimal(val) when is_number(val) and val > 0, do: :ok
  defp validate_decimal(_), do: {:error, :wrong_type}

  defp validate_nullable_map(nil), do: :ok
  defp validate_nullable_map(val) when is_map(val), do: :ok
  defp validate_nullable_map(_), do: {:error, :wrong_type}

  defp validate_token(val) when is_binary(val) and byte_size(val) > 0 and byte_size(val) <= 255,
    do: :ok

  defp validate_token(_), do: {:error, :wrong_type}
end
