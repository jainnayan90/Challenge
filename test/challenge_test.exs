defmodule ChallengeTest do
  use ExUnit.Case
  doctest Challenge

  alias Challenge

  @registry :wallet_registry

    setup_all do
      pid = Challenge.start()
      %{supervisor_pid: pid}
    end

    test "start/0 - starts the supervision tree successfully.", %{supervisor_pid: pid} do
      assert is_pid(pid) == true
    end

    test "create a new user when a valid user id is provided", %{supervisor_pid: pid} do
      user_id = "test_user"
      assert :ok = Challenge.create_users(pid, [user_id])
      [{pid, nil}] = Registry.lookup(@registry, user_id)
      assert is_pid(pid) == true
    end

    test "no user is created when an invalid user id is provided", %{supervisor_pid: pid} do
      user_ids = [:att, ""]
      assert :ok = Challenge.create_users(pid, user_ids)
      assert [] = Registry.lookup(@registry, "")
      assert [] = Registry.lookup(@registry, :att)
    end

    test "user is not re-initialised if we start child again", %{supervisor_pid: pid} do
      user_id = "test_user1"
      assert :ok = Challenge.create_users(pid, [user_id])
      [{pid, nil}] = Registry.lookup(@registry, user_id)
      IO.inspect(pid)
      assert is_pid(pid) == true

      assert :ok = Challenge.create_users(pid, [user_id])
      [{^pid, nil}] = Registry.lookup(@registry, user_id)
    end

end
