defmodule EasypubWeb.AccountsResolverTest do
  @moduledoc """
  Accounts resolver tests
  """
  use EasypubWeb.ConnCase
  alias Easypub.{Accounts}

  @valid_attrs %{
    name: "some name",
    email: "email@email.com",
    password: "test",
    phone: "123123123"
  }

  setup do
    {:ok, user} = Accounts.create_user(@valid_attrs)
    {:ok, token} = Accounts.create_token(%{user_id: user.id})

    {:ok, %{user: %Accounts.User{user | password: nil}, token: token}}
  end

  test "register_user returns auth tokens", %{conn: conn} do
    query = "
    mutation ($input: RegisterUserInput!) {
        registerUser(input: $input) {
          type,
          refreshToken,
          accessToken
        }
      }
    "

    variables = %{
      input: %{
        name: "test name",
        email: "test-email@email.com",
        password: "test-password",
        phone: "some-username"
      }
    }

    response =
      conn
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("registerUser")

    assert response["type"] == "bearer"
    assert is_bitstring(response["accessToken"])
    assert is_bitstring(response["refreshToken"])
  end

  test "login_user return auth tokens", %{conn: conn} do
    query = "
      mutation ($input:LoginUserInput!) {
        loginUser(input: $input) {
          type,
          refreshToken,
          accessToken
        }
      }
    "

    variables = %{
      input: %{
        email: "email@email.com",
        password: "test"
      }
    }

    response =
      conn
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("loginUser")

    assert response["type"] == "bearer"
    assert is_bitstring(response["accessToken"])
    assert is_bitstring(response["refreshToken"])
  end

  test "logout returns string for success", %{conn: conn, user: user, token: token} do
    query = "
      mutation ($refreshToken:String!) {
        logout(refreshToken:$refreshToken)
      }
    "

    variables = %{
      "refreshToken" => token.refresh_token
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("logout")

    assert response == "User logout successfully."
  end

  test "new_access_token return new auth tokens", %{conn: conn, user: user, token: token} do
    query = "
      query ($refreshToken:String!) {
        newAccessToken(refreshToken:$refreshToken) {
          type,
          accessToken,
          refreshToken
        }
      }
    "

    variables = %{
      "refreshToken" => token.refresh_token
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("newAccessToken")

    assert response["type"] == "bearer"
    assert is_bitstring(response["accessToken"])
    assert response["refreshToken"] == token.refresh_token
  end

  test "profile return user info", %{conn: conn, user: user} do
    query = "
      query {
        profile {
          id,
          name,
          insertedAt,
          phone
        }
      }
    "

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query)
      |> get_query_data("profile")

    assert response["id"] == to_string(user.id)
    assert response["name"] == user.name
    assert response["phone"] == user.phone
  end
end
