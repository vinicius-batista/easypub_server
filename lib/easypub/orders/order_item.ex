defmodule Easypub.Orders.OrderItem do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Orders.Order
  alias Easypub.Bars.MenuItem

  schema "order_items" do
    field(:quantity, :integer, default: 1)

    belongs_to(:order, Order, foreign_key: :order_id)
    belongs_to(:menu_item, MenuItem, foreign_key: :item_id)
    timestamps()
  end

  @required_fields ~w(quantity order_id item_id)a
  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
