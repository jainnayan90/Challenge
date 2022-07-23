defmodule ChallengeTest do
  use ExUnit.Case
  doctest Challenge

  @registry :wallet_registry

  setup_all do
    pid = Challenge.start()
    %{supervisor_pid: pid}
  end

  describe "start/0 - " do
    test "starts the supervision tree successfully.", %{supervisor_pid: spid} do
      assert is_pid(spid) == true
    end
  end

  describe "create_users/2" do
    test "create a new user when a valid user id is provided", %{supervisor_pid: spid} do
      user_id = "test_user"
      assert :ok = Challenge.create_users(spid, [user_id])
      [{pid, nil}] = Registry.lookup(@registry, user_id)
      assert is_pid(pid) == true
    end

    test "no user is created when an invalid user id is provided", %{supervisor_pid: spid} do
      user_ids = [:att, ""]
      assert :ok = Challenge.create_users(spid, user_ids)
      assert [] = Registry.lookup(@registry, "")
      assert [] = Registry.lookup(@registry, :att)
    end

    test "user is not re-initialised if we start child again", %{supervisor_pid: spid} do
      user_id = "test_user1"
      assert :ok = Challenge.create_users(spid, [user_id])
      [{pid, nil}] = Registry.lookup(@registry, user_id)
      assert is_pid(pid) == true

      assert :ok = Challenge.create_users(spid, [user_id])
      [{^pid, nil}] = Registry.lookup(@registry, user_id)
    end
  end

  describe "bet/2 - " do
    @bet %{
      user: "john12345",
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
      amount: 1000,
      meta: %{
        selection: "home_team",
        odds: 2.5
      }
    }

    test "places bet successfully for a user if the bet params are valid.", %{
      supervisor_pid: spid
    } do
      user = "nayan"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      request_uuid = "583c985f-fee6-4c0e-bbf5-308aad6265af"

      bet = %{@bet | user: user, request_uuid: request_uuid}

      assert %{
               user: ^user,
               status: "RS_OK",
               request_uuid: ^request_uuid,
               currency: "USD",
               balance: 99_000
             } = Challenge.bet(spid, bet)
    end

    test "returns error id user doesnot exists.", %{supervisor_pid: spid} do
      bet = %{@bet | user: "some user"}

      assert %{status: "RS_ERROR_UNKNOWN"} = Challenge.bet(spid, bet)
    end

    test "does not places bet if transaction uuid is duplicate", %{supervisor_pid: spid} do
      user = "nayan1"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      bet = %{@bet | user: user, amount: 3000}

      assert %{
               user: ^user,
               status: "RS_OK",
               request_uuid: _,
               currency: "USD",
               balance: 97_000
             } = Challenge.bet(spid, bet)

      assert %{
               status: "RS_ERROR_DUPLICATE_TRANSACTION"
             } = Challenge.bet(spid, bet)
    end

    test "does not places bet if bet amount is negative", %{supervisor_pid: spid} do
      user = "nayan2"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      bet = %{@bet | user: user, amount: -200}

      assert %{
               status: "RS_ERROR_WRONG_TYPES"
             } = Challenge.bet(spid, bet)
    end

    test "does not places bet if bet amount is invalid", %{supervisor_pid: spid} do
      user = "nayan3"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      bet = %{@bet | user: user, amount: 200_000}

      assert %{
               status: "RS_ERROR_NOT_ENOUGH_MONEY"
             } = Challenge.bet(spid, bet)
    end

    test "does not places bet if currency code is not USD", %{supervisor_pid: spid} do
      user = "nayan4"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      bet = %{@bet | user: user, amount: 122, currency: "INR"}

      assert %{
               status: "RS_ERROR_WRONG_CURRENCY"
             } = Challenge.bet(spid, bet)
    end

    test "does not places bet if game code is invalid", %{supervisor_pid: spid} do
      user = "nayan5"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      bet = %{@bet | user: user, amount: 122, game_code: ""}

      assert %{
               status: "RS_ERROR_WRONG_TYPES"
             } = Challenge.bet(spid, bet)
    end

    test "returns error when payload is incorrect.", %{supervisor_pid: spid} do
      user = "nayan5"
      assert :ok = Challenge.create_users(spid, [user])
      [{pid, nil}] = Registry.lookup(@registry, user)
      assert is_pid(pid) == true

      bet = %{
        user: user,
        transaction_uuid: "16d2dcfe-b89e-11e7-854a-58404eea6d16",
        supplier_transaction_id: "41ecc3ad-b181-4235-bf9d-acf0a7ad9730",
        token: "55b7518e-b89e-11e7-81be-58404eea6d16",
        supplier_user: "cg_45141",
        bet: "zero",
        amount: 1000,
        meta: %{
          selection: "home_team",
          odds: 2.5
        }
      }

      assert %{
               status: "RS_ERROR_WRONG_SYNTAX"
             } = Challenge.bet(spid, bet)
    end
  end
end
