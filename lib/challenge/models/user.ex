defmodule Challenge.Models.User do
  @moduledoc """
  This module creates a model for users.
  """

  @enforce_keys [
    :id
  ]

  defstruct id: nil, currency: "USD", amount: 100_000

  @type t :: %__MODULE__{
          id: String.t(),
          currency: String.t(),
          amount: Decimal.t()
        }

  @spec new(%{id: String.t()}) :: Challenge.Models.User.t() | {:error, :invalid_name}
  def new(%{id: id}) when is_binary(id) and byte_size(id) > 0, do: %__MODULE__{id: id}
  def new(_), do: {:error, :invalid_name}
end
