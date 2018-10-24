defmodule Easypub.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Easypub.Repo

  alias Easypub.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(clauses \\ []), do: Repo.get_by(User, clauses)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  alias Easypub.Accounts.Token

  def get_token_by(clauses \\ []), do: Repo.get_by(Token, clauses)

  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end
end
