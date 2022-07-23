defmodule Challenge.Models.WinTest do
  use ExUnit.Case

  doctest Challenge.Models.Win

  alias Challenge.Models.Win

  @win %{
    user: "nayan",
    transaction_uuid: "16d2dcfe-b89e-11e7-854a-58404eea6d16",
    supplier_transaction_id: "41ecc3ad-b181-4235-bf9d-acf0a7ad9730",
    token: "55b7518e-b89e-11e7-81be-58404eea6d16",
    supplier_user: "cg_45141",
    round_closed: true,
    round: "rNEMwgzJAOZ6eR3V",
    reward_uuid: "a28f93f2-98c5-41f7-8fbb-967985acf8fe",
    request_uuid: "583c985f-fee6-4c0e-bbf5-308aad6265af",
    reference_transaction_uuid: "583c985f-fee6-4c0e-bbf5-308aad6265af",
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
    assert %Win{
             user: "nayan",
             transaction_uuid: "16d2dcfe-b89e-11e7-854a-58404eea6d16",
             supplier_transaction_id: "41ecc3ad-b181-4235-bf9d-acf0a7ad9730",
             token: "55b7518e-b89e-11e7-81be-58404eea6d16",
             supplier_user: "cg_45141",
             round_closed: true,
             round: "rNEMwgzJAOZ6eR3V",
             reward_uuid: "a28f93f2-98c5-41f7-8fbb-967985acf8fe",
             request_uuid: "583c985f-fee6-4c0e-bbf5-308aad6265af",
             reference_transaction_uuid: "583c985f-fee6-4c0e-bbf5-308aad6265af",
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
           } = Win.new(@win)
  end

  test "returns error if token is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | token: ""})
  end

  test "returns error if supplier_user is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | supplier_user: ""})
  end

  test "returns error if round_closed is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | round_closed: ""})
  end

  test "returns error if round is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | round: ""})
  end

  test "returns error if reward_uuid is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | reward_uuid: ""})
  end

  test "returns error if request_uuid is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | request_uuid: ""})
  end

  test "returns error if reference_transaction_uuid is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | reference_transaction_uuid: ""})
  end

  test "returns error if is_free is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | is_free: ""})
  end

  test "returns error if is_aggregated is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | is_aggregated: ""})
  end

  test "returns error if bet is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | bet: ""})
  end

  test "returns error if meta is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | meta: ""})
  end

  test "returns error if supplier_transaction_id is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | supplier_transaction_id: ""})
  end

  test "returns error if user is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | user: ""})
  end

  test "returns error if transaction_uuid is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | transaction_uuid: ""})
  end

  test "returns error if game_code is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | game_code: ""})
  end

  test "returns error if currency is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | currency: ""})
  end

  test "returns error if amount is invalid" do
    assert {:error, :wrong_type} = Win.new(%{@win | amount: -10})
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

    assert {:error, :invalid_bet} = Win.new(bet)
  end
end
