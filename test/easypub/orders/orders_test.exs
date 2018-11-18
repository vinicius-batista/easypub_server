defmodule Easypub.OrdersTest do
  use Easypub.DataCase

  alias Easypub.Orders
  alias Easypub.Bars
  alias Easypub.{BarsTest, AccountsTest}

  describe "orders" do
    alias Easypub.Orders.Order

    @valid_attrs %{status: "aberto"}
    @invalid_attrs %{status: nil, table_id: nil, user_id: nil}

    def order_fixture(attrs \\ %{}) do
      table = BarsTest.table_fixture()
      user = AccountsTest.user_fixture()

      {:ok, order} =
        attrs
        |> Enum.into(%{table_id: table.id, user_id: user.id})
        |> Enum.into(@valid_attrs)
        |> Orders.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      %{user_id: user_id} = order = order_fixture()
      assert Orders.list_orders(user_id) == [order]
    end

    test "list_active_orders/3 returns all active orders from a bar" do
      order = order_fixture()
      table = Bars.get_table(order.table_id)

      orders = Orders.list_active_orders(table.bar_id)

      assert orders == [order]
    end

    test "get_order/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      table = BarsTest.table_fixture()
      user = AccountsTest.user_fixture()

      attrs =
        @valid_attrs
        |> Enum.into(%{table_id: table.id, user_id: user.id})

      assert {:ok, %Order{} = order} = Orders.create_order(attrs)
      assert order.status == "aberto"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "close_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = Orders.close_order(order)
      assert %Order{} = order
      assert order.status == "fechado"
    end
  end

  describe "order_items" do
    alias Easypub.Orders.OrderItem

    @valid_attrs %{quantity: 42, note: "some note"}
    @invalid_attrs %{quantity: nil, note: nil}

    def order_item_fixture(attrs \\ %{}) do
      item = BarsTest.menu_item_fixture()
      order = order_fixture()

      {:ok, order_item} =
        attrs
        |> Enum.into(%{item_id: item.id, order_id: order.id})
        |> Enum.into(@valid_attrs)
        |> Orders.create_order_item()

      order_item
    end

    test "add_item_to_order/2 returns order item and created an order" do
      item = BarsTest.menu_item_fixture()
      user = AccountsTest.user_fixture()
      table = BarsTest.table_fixture()

      assert {:ok, %OrderItem{} = order_item} =
               %{item_id: item.id, quantity: 2, table_id: table.id}
               |> Orders.add_item_to_order(user)

      assert order_item.item_id == item.id
      assert order_item.quantity == 2

      assert is_nil(Orders.get_order_by(table_id: table.id)) == false
    end

    test "add_item_to_order/2 returns order item and added to an existed order" do
      item = BarsTest.menu_item_fixture()
      order = order_fixture()

      assert {:ok, %OrderItem{} = order_item} =
               %{item_id: item.id, table_id: order.table_id}
               |> Enum.into(@valid_attrs)
               |> Orders.add_item_to_order(%{id: order.user_id})

      assert order_item.item_id == item.id
      assert order_item.quantity == 42
      assert order_item.note == "some note"
    end

    test "get_order_item!/1 returns the order_item with given id" do
      order_item = order_item_fixture()
      assert Orders.get_order_item!(order_item.id) == order_item
    end

    test "create_order_item/1 with valid data creates a order_item" do
      item = BarsTest.menu_item_fixture()
      order = order_fixture()

      attrs =
        @valid_attrs
        |> Enum.into(%{item_id: item.id, order_id: order.id})

      assert {:ok, %OrderItem{} = order_item} = Orders.create_order_item(attrs)
      assert order_item.quantity == 42
      assert order_item.note == "some note"
    end

    test "create_order_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order_item(@invalid_attrs)
    end

    test "delete_order_item/1 deletes the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{}} = Orders.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_item!(order_item.id) end
    end
  end

  describe "feedbacks" do
    alias Easypub.Orders.Feedback

    @valid_attrs %{app_rating: "2.5", bar_rating: "2.5", has_mistake: true, indication: 8}
    @invalid_attrs %{app_rating: nil, bar_rating: nil, has_mistake: nil, indication: nil}

    def feedback_fixture(attrs \\ %{}) do
      order = order_fixture()

      {:ok, feedback} =
        attrs
        |> Enum.into(%{order_id: order.id})
        |> Enum.into(@valid_attrs)
        |> Orders.create_feedback()

      feedback
    end

    test "create_feedback/1 with valid data creates a feedback" do
      order = order_fixture()

      attrs =
        %{order_id: order.id}
        |> Enum.into(@valid_attrs)

      assert {:ok, %Feedback{} = feedback} = Orders.create_feedback(attrs)
      assert feedback.app_rating == Decimal.new("2.5")
      assert feedback.bar_rating == Decimal.new("2.5")
      assert feedback.has_mistake == true
      assert feedback.indication == 8
    end

    test "create_feedback/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_feedback(@invalid_attrs)
    end

    test "get_feedback_by/1 with valid order_id" do
      feedback = feedback_fixture()
      assert Orders.get_feedback_by(order_id: feedback.order_id) == feedback
    end
  end
end
