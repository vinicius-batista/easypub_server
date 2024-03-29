defmodule Easypub.AuthTest do
  @moduledoc """
  Auth module test
  """
  use Easypub.DataCase
  alias Easypub.Accounts
  alias Easypub.Accounts.Auth

  @valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test",
    phone: "31432144"
  }

  setup do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, token} = Accounts.create_token(%{user_id: user.id})
    {:ok, %{user: %Accounts.User{user | password: nil}, refresh_token: token.refresh_token}}
  end

  test "check_password returns true for correct password", %{user: user} do
    assert Auth.check_password(user, "test") == true
  end

  test "check_password returns false for incorrect password", %{user: user} do
    assert Auth.check_password(user, "test-password") == false
  end

  test "check_password returns an error if user is nil" do
    assert Auth.check_password(nil, "test") ==
             {:error, "Não foi encontrado alguém com este email"}
  end

  test "find_user_and_check_password returns user with correct email and pass", %{user: user} do
    {:ok, user_auth} = Auth.find_user_and_check_password("email@email.com", "test")
    assert user_auth == user
  end

  test "find_user_and_check_password returns error with incorrect pass" do
    assert Auth.find_user_and_check_password("email@email.com", "password") ==
             {:error, "Senha incorreta"}
  end

  test "find_user_and_check_password returns error with incorrect email" do
    assert Auth.find_user_and_check_password("emaiemail.com", "password") ==
             {:error, "Não foi encontrado alguém com este email"}
  end

  test "generate_tokens returns all auth tokens", %{user: user} do
    with {:ok, tokens} <- Auth.generate_tokens(user) do
      assert is_map(tokens)
      assert is_bitstring(tokens.type)
      assert is_bitstring(tokens.access_token)
      assert is_bitstring(tokens.refresh_token)
    end
  end

  test "generate_tokens returns error" do
    response = Auth.generate_tokens(%{})
    assert response == {:error, "Unknow resource type"}
  end

  test "generate_new_access_token returns new auth tokens", %{
    user: user,
    refresh_token: refresh_token
  } do
    {:ok, tokens} = Auth.generate_new_access_token(user, refresh_token)
    assert is_map(tokens)
    assert is_bitstring(tokens.type)
    assert is_bitstring(tokens.access_token)
    assert is_bitstring(tokens.refresh_token)
    assert tokens.refresh_token == refresh_token
  end

  test "get_user_by_refresh_token returns user", %{
    user: user,
    refresh_token: refresh_token
  } do
    {:ok, user_by_token} = Auth.get_user_by_refresh_token(refresh_token)
    assert user == user_by_token
  end

  test "get_user_by_refresh_token returns error" do
    assert Auth.get_user_by_refresh_token("test") ==
             {:error, "Could not find user with refresh token provided"}
  end

  test "revoke_refresh_token return ok and token revoked", %{
    user: user,
    refresh_token: refresh_token
  } do
    {:ok, token} = Auth.revoke_refresh_token(refresh_token, user.id)
    assert token.refresh_token == refresh_token
    assert token.is_revoked
  end

  test "revoke_refresh_token return error could not find", %{
    refresh_token: refresh_token
  } do
    {:error, reason} =
      Auth.revoke_refresh_token(refresh_token, "89fc29d9-5f86-4e6a-a1e1-af0ae2cfabe3")

    assert "Não foi possível encontrar o token informado" == reason
  end
end
