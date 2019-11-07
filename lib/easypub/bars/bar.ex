defmodule Easypub.Bars.Bar do
  @moduledoc """
  Model for Bar
  """
  use Easypub.Schema
  import Ecto.Changeset
  alias Easypub.Accounts.User
  alias Easypub.Bars.{MenuCategory, Table}
  alias Easypub.Images

  schema "bars" do
    field(:address, :string)
    field(:avatar, :string)
    field(:name, :string)
    field(:status, :string, default: "fechado")
    field(:avatar_file, Images.UploadType, virtual: true)

    timestamps()
    belongs_to(:user, User, foreign_key: :user_id)
    has_many(:menu_categories, MenuCategory, on_delete: :delete_all)
    has_many(:tables, Table, on_delete: :delete_all)
  end

  @required_fields ~w(address name)a
  @all_fields ~w(status avatar user_id avatar_file)a ++ @required_fields

  @doc false
  def changeset(bar, attrs) do
    bar
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end

  defp upload_avatar(%Ecto.Changeset{valid?: true, changes: %{avatar_file: avatar}} = changeset) do
    changeset
    |> put_change(:avatar, Images.upload(avatar, "bars"))
  end

  defp upload_avatar(changeset), do: changeset
end
