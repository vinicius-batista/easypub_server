defmodule Easypub.Orders.Order do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Accounts.User
  alias Easypub.Bars.Table
  alias Easypub.Orders.{OrderItem, Feedback}

  schema "orders" do
    field(:status, :string, default: "aberto")

    belongs_to(:table, Table, foreign_key: :table_id)
    belongs_to(:user, User, foreign_key: :user_id)
    has_many(:items, OrderItem, foreign_key: :order_id)
    has_one(:feedback, Feedback, foreign_key: :order_id)
    timestamps()
  end

  @required_fields ~w(table_id user_id)a
  @all_fields ~w(status)a ++ @required_fields
  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
