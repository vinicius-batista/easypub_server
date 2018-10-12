defmodule EasypubWeb.Resolvers.OrdersResolvers do
  @moduledoc """
  Module for Orders Resolvers
  """

  alias Easypub.Orders

  def add_item_to_order(_, %{input: input}, %{context: %{current_user: current_user}}) do
    Orders.add_item_to_order(input, current_user)
  end
end
