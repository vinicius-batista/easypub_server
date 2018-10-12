defmodule EasypubWeb.Schema.OrdersTypes do
  @moduledoc """
  Module for Graphql Scheme for Orders
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Easypub.Bars.{Table, MenuItem}
  alias Easypub.Accounts.User
  alias Easypub.Orders.OrderItem
  alias EasypubWeb.Middlewares.{Authentication, HandleErrors}
  alias EasypubWeb.Resolvers.OrdersResolvers

  @desc "Object for order type"
  object :order do
    field(:id, :id)
    field(:status, :string)
    field(:table, :table, resolve: dataloader(Table))
    field(:user, :user, resolve: dataloader(User))
    field(:order_items, :order_item, resolve: dataloader(OrderItem))
  end

  @desc "Object for order_item type"
  object :order_item do
    field(:id, :id)
    field(:quantity, :integer)
    field(:note, :string)
    field(:menu_item, :menu_item, resolve: dataloader(MenuItem))
  end

  input_object :add_item_input do
    field(:table_id, non_null(:string))
    field(:item_id, non_null(:string))
    field(:quantity, non_null(:integer))
    field(:note, :string)
  end

  object :orders_mutations do
    field :add_item_to_order, :order_item do
      arg(:input, non_null(:add_item_input))
      middleware(Authentication)
      resolve(&OrdersResolvers.add_item_to_order/3)
      middleware(HandleErrors)
    end

    field :close_order, :order do
      arg(:order_id, :string)
      middleware(Authentication)
      resolve(&OrdersResolvers.close_order/3)
      middleware(HandleErrors)
    end
  end
end
