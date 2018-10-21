defmodule Easypub.Orders.Feedback do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Orders.Order

  schema "feedbacks" do
    field(:app_rating, :decimal)
    field(:bar_rating, :decimal)
    field(:has_mistake, :boolean, default: false)
    field(:indication, :integer)

    belongs_to(:order, Order, foreign_key: :order_id)

    timestamps()
  end

  @required_fields ~w(order_id)a
  @all_fields ~w(has_mistake bar_rating app_rating indication)a ++ @required_fields

  @doc false
  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_number(:app_rating, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:bar_rating, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> validate_number(:indication, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
  end
end
