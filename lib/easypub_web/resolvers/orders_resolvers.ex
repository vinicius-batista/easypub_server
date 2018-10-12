defmodule EasypubWeb.Resolvers.OrdersResolvers do
  @moduledoc """
  Module for Orders Resolvers
  """

  alias Easypub.Orders

  def add_item_to_order(_, %{input: input}, %{context: %{current_user: current_user}}) do
    Orders.add_item_to_order(input, current_user)
  end

  def close_order(_, %{order_id: order_id}, %{context: %{current_user: current_user}}) do
    order = Orders.get_order(order_id)

    with :ok <- Bodyguard.permit(Orders, :close_order, current_user, order),
         do: Orders.update_order(order, %{status: "fechado"})
  end

  def current_order(_, _, %{context: %{current_user: current_user}}) do
    order = Orders.get_order_by(user_id: current_user.id, status: "aberto")
    {:ok, order}
  end

  def get_orders(_, %{cursor: cursor, limit: limit}, %{context: %{current_user: current_user}}) do
    orders = Orders.list_orders(current_user.id, limit, cursor)
    {:ok, orders}
  end
end
