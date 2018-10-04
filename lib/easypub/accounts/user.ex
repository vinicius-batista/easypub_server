defmodule Easypub.Accounts.User do
  @moduledoc """
  Model for User
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Easypub.Accounts.{Encryption}

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:phone, :string)
    field(:role, :string, default: "user")

    timestamps()
  end

  @required_fields ~w(email name password_hash phone)a
  @all_fields ~w(password role)a ++ @required_fields
  @roles ~w(user admin)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> hash_password()
    |> validate_required(@required_fields)
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:phone, name: :users_phone_index)
    |> validate_inclusion(:role, @roles, message: "should be one of: [#{Enum.join(@roles, " ")}]")
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:password_hash, Encryption.password_hashing(pass))
  end

  defp hash_password(changeset), do: changeset
end
