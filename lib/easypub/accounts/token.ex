defmodule Easypub.Accounts.Token do
  @moduledoc """
  Model for Token
  """
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Accounts.User
  alias Ecto.UUID

  schema "tokens" do
    field(:is_revoked, :boolean, default: false)
    field(:refresh_token, :string)
    field(:type, :string)

    timestamps()
    belongs_to(:user, User, foreign_key: :user_id)
  end

  @required_fields ~w(refresh_token user_id)a
  @all_fields ~w(is_revoked type)a ++ @required_fields

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, @all_fields)
    |> generate_refresh_token()
    |> validate_required(@required_fields)
    |> unique_constraint(:refresh_token, name: :tokens_refresh_token_index)
  end

  defp generate_refresh_token(changeset) do
    with nil <- get_field(changeset, :refresh_token, nil) do
      refresh_token =
        :sha256
        |> :crypto.hash(UUID.generate())
        |> Base.encode16(case: :lower)

      changeset
      |> put_change(:refresh_token, refresh_token)
    else
      _ -> changeset
    end
  end
end
