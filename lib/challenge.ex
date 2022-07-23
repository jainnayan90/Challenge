defmodule Challenge do
  @moduledoc """
  This module implements public api for wallet operations for operators.
  """

  alias Challenge.Operator, as: Operator

  defdelegate start, to: Operator
  defdelegate create_users(server, users), to: Operator
  defdelegate bet(server, body), to: Operator
  defdelegate win(server, body), to: Operator
end
