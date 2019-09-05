defmodule Easypub.AccountsTest do
  @moduledoc """
  Tests for Accounts models
  """
  use Easypub.DataCase

  alias Easypub.Accounts

  describe "users" do
    alias Easypub.Accounts.User
    alias Easypub.Bars.Bar

    @valid_attrs %{
      email: "contato@easypub.com.br",
      name: "some name",
      password: "some password",
      phone: "12312312313"
    }
    @bar_owner_valid_attrs %{
      bar_address: "some address",
      bar_avatar_link: "some avatar",
      bar_name: "some name",
      email: "contato@easypub.com.br",
      name: "some name",
      password: "some password",
      phone: "12312312313"
    }
    @update_attrs %{
      email: "contato@easypub.com.br",
      name: "some updated name",
      password: "some updated password",
      phone: "12313"
    }
    @invalid_attrs %{email: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      user = %User{user | password: nil}

      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "contato@easypub.com.br"
      assert user.name == "some name"
      assert user.role == "user"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_bar_owner/1 with valid data creates a user and a bar" do
      assert {:ok, %{user: %User{} = user, bar: %Bar{} = bar}} =
               %{
                 bar_avatar: %Plug.Upload{
                   path: "test/support/test_image.jpg",
                   content_type: "jpg",
                   filename: "Some random name"
                 }
               }
               |> Enum.into(@bar_owner_valid_attrs)
               |> Accounts.create_bar_owner()

      assert user.email == "contato@easypub.com.br"
      assert user.name == "some name"
      assert user.role == "bar_owner"
      assert bar.name == "some name"
      assert String.valid?(bar.avatar)
      assert bar.address == "some address"
      assert bar.user_id == user.id
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "contato@easypub.com.br"
      assert user.name == "some updated name"
      assert user.role == "user"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      user = %User{user | password: nil}

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end
  end

  describe "tokens" do
    alias Easypub.Accounts.Token

    @valid_attrs %{}
    @update_attrs %{is_revoked: true}
    @invalid_attrs %{user_id: nil}

    def token_fixture(attrs \\ %{}) do
      user = user_fixture()

      {:ok, token} =
        attrs
        |> Enum.into(%{user_id: user.id})
        |> Enum.into(@valid_attrs)
        |> Accounts.create_token()

      token
    end

    test "create_token/1 with valid data creates a token" do
      user = user_fixture()

      attrs =
        @valid_attrs
        |> Enum.into(%{user_id: user.id})

      assert {:ok, %Token{}} = Accounts.create_token(attrs)
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, _} = Accounts.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, token} = Accounts.update_token(token, @update_attrs)
      assert %Token{} = token
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, _} = Accounts.update_token(token, @invalid_attrs)
      assert token == Repo.get(Token, token.id)
    end
  end
end
