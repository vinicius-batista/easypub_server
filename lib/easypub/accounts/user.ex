defmodule Easypub.Accounts.User do
  @moduledoc """
  Model for User
  """
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Accounts.{Encryption, Token}
  alias Easypub.Bars.Bar

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:phone, :string)
    field(:role, :string, default: "user")

    timestamps()
    has_many(:tokens, Token, on_delete: :delete_all)
    has_one(:bar, Bar, on_delete: :delete_all)
  end

  @required_fields ~w(email name password_hash phone)a
  @all_fields ~w(password role)a ++ @required_fields
  @roles ~w(user admin bar_owner)

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> hash_password()
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:phone, name: :users_phone_index)
    |> validate_inclusion(:role, @roles, message: "should be one of: [#{Enum.join(@roles, " ")}]")
    |> validate_email()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:password_hash, Encryption.password_hashing(pass))
  end

  defp hash_password(changeset), do: changeset

  defp validate_email(changeset) do
    changeset
    |> get_field(:email)
    |> check_email(changeset)
  end

  defp check_email(nil, changeset), do: changeset

  defp check_email(email, changeset) do
    case EmailChecker.valid?(email) do
      true -> changeset
      false -> add_error(changeset, :email, "has invalid format", validation: :format)
    end
  end
end
