defmodule Easypub.Bars.Table do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Bars.Bar
  alias Easypub.Orders.Order

  schema "tables" do
    field(:number, :integer)

    belongs_to(:bar, Bar, foreign_key: :bar_id)
    has_many(:orders, Order)
    timestamps()
  end

  @required_fields ~w(number bar_id)a
  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
