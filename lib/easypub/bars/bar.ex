defmodule Easypub.Bars.Bar do
  @moduledoc """
  Model for Bar
  """
  use Easypub.Schema
  import Ecto.Changeset
  alias Easypub.Accounts.User
  alias Easypub.Bars.MenuCategory

  schema "bars" do
    field(:address, :string)
    field(:avatar, :string)
    field(:name, :string)
    field(:status, :string, default: "fechado")

    timestamps()
    belongs_to(:user, User, foreign_key: :user_id)
    has_many(:menu_categories, MenuCategory, on_delete: :delete_all)
  end

  @required_fields ~w(address name avatar)a
  @all_fields ~w(status)a ++ @required_fields

  @doc false
  def changeset(bar, attrs) do
    bar
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
