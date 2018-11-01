defmodule Easypub.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Easypub.Repo

  alias Easypub.Orders.Order
  alias Easypub.Bars.Table

  defdelegate authorize(action, user, params), to: __MODULE__.Policy

  def add_item_to_order(attrs, user) do
    item_attrs = Map.take(attrs, [:quantity, :item_id, :note])

    case get_order_by(table_id: attrs.table_id, status: "aberto", user_id: user.id) do
      nil ->
        {:ok, order} = create_order(%{table_id: attrs.table_id, user_id: user.id})

        %{order_id: order.id}
        |> Enum.into(item_attrs)
        |> create_order_item()

      order ->
        %{order_id: order.id}
        |> Enum.into(item_attrs)
        |> create_order_item()
    end
  end

  def get_order_by(clauses \\ []), do: Repo.get_by(Order, clauses)

  def current_order(%{id: id}), do: get_order_by(user_id: id, status: "aberto")

  def list_orders(user_id, limit \\ 20, cursor \\ DateTime.utc_now()) do
    from(
      order in Order,
      where: order.user_id == ^user_id and order.inserted_at < ^cursor,
      order_by: [desc: order.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  def list_active_orders(bar_id, limit \\ 20, cursor \\ DateTime.utc_now()) do
    table_subquery = from(table in Table, where: table.bar_id == ^bar_id, select: table.id)

    from(
      order in Order,
      join: table in subquery(table_subquery),
      on: table.id == order.table_id,
      where: order.inserted_at < ^cursor and order.status == "aberto",
      order_by: [desc: order.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  def get_order_with_table(id) do
    from(order in Order,
      join: table in assoc(order, :table),
      preload: [:table],
      where: order.id == ^id
    )
    |> Repo.one()
  end

  def get_order(id), do: Repo.get(Order, id)

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def close_order(%Order{} = order) do
    order
    |> Order.changeset(%{status: "fechado"})
    |> Repo.update()
  end

  alias Easypub.Orders.OrderItem

  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  alias Easypub.Orders.Feedback

  def get_feedback_by(clauses \\ []), do: Repo.get_by(Feedback, clauses)

  def create_feedback(attrs \\ %{}) do
    %Feedback{}
    |> Feedback.changeset(attrs)
    |> Repo.insert()
  end
end
