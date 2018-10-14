defmodule EasypubWeb.Resolvers.OrdersResolvers do
  @moduledoc """
  Module for Orders Resolvers
  """

  alias Easypub.{Orders, Bars}

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

  def get_order(_, %{id: id}, %{context: %{current_user: current_user}}) do
    order = Orders.get_order(id)
    with :ok <- Bodyguard.permit(Orders, :get_order, current_user, order), do: {:ok, order}
  end

  def order_item_requested(%{bar_id: bar_id}, %{context: context}) do
    if Map.has_key?(context, :current_user) do
      bar = Bars.get_bar(bar_id)

      with :ok <- Bodyguard.permit(Orders, :order_item_requested, context.current_user, bar),
           do: {:ok, topic: bar_id}
    else
      {:error, :invalid_token}
    end
  end

  def order_item_requested_trigger(%{order_id: order_id}) do
    %{table: table} = Orders.get_order_with_table(order_id)
    table.bar_id
  end
end
