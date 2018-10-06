defmodule Easypub.Bars.MenuCategory do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Bars.{Bar, MenuItem}

  schema "menu_categories" do
    field(:name, :string)

    timestamps()
    belongs_to(:bar, Bar, foreign_key: :bar_id)
    has_many(:menu_items, MenuItem, foreign_key: :category_id, on_delete: :delete_all)
  end

  @required_fields ~w(name bar_id)a
  @doc false
  def changeset(menu_category, attrs) do
    menu_category
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
