defmodule Challenge.Models.BetTest do
  use ExUnit.Case

  doctest Challenge.Models.Bet

  alias Challenge.Models.Bet

  @bet %{
    user: "nayan",
    transaction_uuid: "16d2dcfe-b89e-11e7-854a-58404eea6d16",
    supplier_transaction_id: "41ecc3ad-b181-4235-bf9d-acf0a7ad9730",
    token: "55b7518e-b89e-11e7-81be-58404eea6d16",
    supplier_user: "cg_45141",
    round_closed: true,
    round: "rNEMwgzJAOZ6eR3V",
    reward_uuid: "a28f93f2-98c5-41f7-8fbb-967985acf8fe",
    request_uuid: "583c985f-fee6-4c0e-bbf5-308aad6265af",
    is_free: false,
    is_aggregated: false,
    game_code: "clt_dragonrising",
    currency: "USD",
    bet: "zero",
    amount: 100,
    meta: %{
      selection: "home_team",
      odds: 2.5
    }
  }

  test "returns a new model if request params are valid" do
    assert %Bet{
      user: "nayan",
      transaction_uuid: "16d2dcfe-b89e-11e7-854a-58404eea6d16",
      supplier_transaction_id: "41ecc3ad-b181-4235-bf9d-acf0a7ad9730",
      token: "55b7518e-b89e-11e7-81be-58404eea6d16",
      supplier_user: "cg_45141",
      round_closed: true,
      round: "rNEMwgzJAOZ6eR3V",
      reward_uuid: "a28f93f2-98c5-41f7-8fbb-967985acf8fe",
      request_uuid: "583c985f-fee6-4c0e-bbf5-308aad6265af",
      is_free: false,
      is_aggregated: false,
      game_code: "clt_dragonrising",
      currency: "USD",
      bet: "zero",
      amount: 100,
      meta: %{
        selection: "home_team",
        odds: 2.5
      }
     } = Bet.new(@bet)
  end

  test "returns error if user is invalid" do
    assert {:error, :invalid_user} = Bet.new(%{ @bet | user: ""})
  end

  test "returns error if transaction_uuid is invalid" do
    assert {:error, :invalid_transaction_uuid} = Bet.new(%{ @bet | transaction_uuid: ""})
  end

  test "returns error if game_code is invalid" do
    assert {:error, :invalid_game_code} = Bet.new(%{ @bet | game_code: ""})
  end

  test "returns error if currency is invalid" do
    assert {:error, :invalid_currency} = Bet.new(%{ @bet | currency: "INR"})
  end

  test "returns error if amount is invalid" do
    assert {:error, :invalid_amount} = Bet.new(%{ @bet | amount: -10})
  end

  test "returns error if body params are missing is invalid" do

    bet = %{
      user: "nayan",
      transaction_uuid: "16d2dcfe-b89e-11e7-854a-58404eea6d16",
      supplier_transaction_id: "41ecc3ad-b181-4235-bf9d-acf0a7ad9730",
      token: "55b7518e-b89e-11e7-81be-58404eea6d16",
      supplier_user: "cg_45141",
      round_closed: true,
      round: "rNEMwgzJAOZ6eR3V",
      reward_uuid: "a28f93f2-98c5-41f7-8fbb-967985acf8fe",
      is_free: false,
      is_aggregated: false,
      game_code: "clt_dragonrising",
      currency: "USD",
      bet: "zero",
      amount: 100,
      meta: %{
        selection: "home_team",
        odds: 2.5
      }
    }
    assert {:error, :invalid_bet} = Bet.new(bet)
  end
end
