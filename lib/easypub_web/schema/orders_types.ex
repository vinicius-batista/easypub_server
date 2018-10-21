defmodule EasypubWeb.Schema.OrdersTypes do
  @moduledoc """
  Module for Graphql Scheme for Orders
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Easypub.Bars.{Table, MenuItem}
  alias Easypub.Accounts.User
  alias Easypub.Orders.{OrderItem, Order, Feedback}
  alias EasypubWeb.Middlewares.{Authentication, HandleErrors}
  alias EasypubWeb.Resolvers.OrdersResolvers

  @desc "Object for order type"
  object :order do
    field(:id, :id)
    field(:status, :string)
    field(:inserted_at, :string)
    field(:table, :table, resolve: dataloader(Table))
    field(:user, :user, resolve: dataloader(User))
    field(:items, list_of(:order_item), resolve: dataloader(OrderItem))
    field(:feedback, :feedback, resolve: dataloader(Feedback))
  end

  @desc "Object for order_item type"
  object :order_item do
    field(:id, :id)
    field(:quantity, :integer)
    field(:note, :string)
    field(:inserted_at, :string)
    field(:order, :order, resolve: dataloader(Order))
    field(:menu_item, :menu_item, resolve: dataloader(MenuItem))
  end

  @desc "Object for feedback type"
  object :feedback do
    field(:id, :id)
    field(:app_rating, :float)
    field(:bar_rating, :float)
    field(:has_mistake, :boolean)
    field(:indication, :integer)
    field(:order, :order, resolve: dataloader(Order))
  end

  input_object :add_item_input do
    field(:table_id, non_null(:string))
    field(:item_id, non_null(:string))
    field(:quantity, non_null(:integer))
    field(:note, :string)
  end

  input_object :create_feedback_input do
    field(:order_id, non_null(:string))
    field(:app_rating, :float)
    field(:bar_rating, :float)
    field(:has_mistake, :boolean)
    field(:indication, :integer)
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

    field :create_feedback, :feedback do
      arg(:input, non_null(:create_feedback_input))
      middleware(Authentication)
      resolve(&OrdersResolvers.create_feedback/3)
      middleware(HandleErrors)
    end
  end

  object :orders_queries do
    field :current_order, :order do
      middleware(Authentication)
      resolve(&OrdersResolvers.current_order/3)
    end

    field :orders, list_of(:order) do
      arg(:limit, :integer, default_value: 20)
      arg(:cursor, :string, default_value: DateTime.utc_now())
      middleware(Authentication)
      resolve(&OrdersResolvers.get_orders/3)
    end

    field :order, :order do
      arg(:id, :string)
      middleware(Authentication)
      resolve(&OrdersResolvers.get_order/3)
    end

    field :feedback, :feedback do
      arg(:order_id, non_null(:string))
      middleware(Authentication)
      resolve(&OrdersResolvers.get_feedback/3)
    end
  end

  object :orders_subscriptions do
    field :order_item_requested, :order_item do
      arg(:bar_id, non_null(:string))
      config(&OrdersResolvers.order_subscription_config/2)

      trigger(
        :add_item_to_order,
        topic: &OrdersResolvers.order_item_requested_trigger/1
      )
    end

    field :order_closed, :order do
      arg(:bar_id, non_null(:string))
      config(&OrdersResolvers.order_subscription_config/2)

      trigger(
        :close_order,
        topic: &OrdersResolvers.order_closed_trigger/1
      )
    end
  end
end
