defmodule Easypub.Bars.MenuItem do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Bars.MenuCategory

  schema "menu_items" do
    field(:name, :string)
    field(:photo, :string)
    field(:price, :decimal)
    field(:description, :string)
    field(:waiting_time, :string)
    field(:people_count, :integer)

    timestamps()
    belongs_to(:menu_category, MenuCategory, foreign_key: :category_id)
  end

  @required_fields ~w(name price description category_id)a
  @all_fields ~w(photo waiting_time)a ++ @required_fields

  @doc false
  def changeset(menu_item, attrs) do
    menu_item
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
