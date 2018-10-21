defmodule Easypub.OrdersTest do
  use Easypub.DataCase

  alias Easypub.Orders
  alias Easypub.{BarsTest, AccountsTest}

  describe "orders" do
    alias Easypub.Orders.Order

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
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
      order = order_fixture()
      assert Orders.list_orders(order.user_id) == [order]
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
      assert order.status == "some status"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = Orders.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.status == "some updated status"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert is_nil(Orders.get_order(order.id))
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end

  describe "order_items" do
    alias Easypub.Orders.OrderItem

    @valid_attrs %{quantity: 42, note: "some note"}
    @update_attrs %{quantity: 43, note: "some updated note"}
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

    test "list_order_items/0 returns all order_items" do
      order_item = order_item_fixture()
      assert Orders.list_order_items() == [order_item]
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

    test "update_order_item/2 with valid data updates the order_item" do
      order_item = order_item_fixture()
      assert {:ok, order_item} = Orders.update_order_item(order_item, @update_attrs)
      assert %OrderItem{} = order_item
      assert order_item.quantity == 43
      assert order_item.note == "some updated note"
    end

    test "update_order_item/2 with invalid data returns error changeset" do
      order_item = order_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order_item(order_item, @invalid_attrs)
      assert order_item == Orders.get_order_item!(order_item.id)
    end

    test "delete_order_item/1 deletes the order_item" do
      order_item = order_item_fixture()
      assert {:ok, %OrderItem{}} = Orders.delete_order_item(order_item)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_item!(order_item.id) end
    end

    test "change_order_item/1 returns a order_item changeset" do
      order_item = order_item_fixture()
      assert %Ecto.Changeset{} = Orders.change_order_item(order_item)
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

    test "list_feedbacks/0 returns all feedbacks" do
      feedback = feedback_fixture()
      assert Orders.list_feedbacks() == [feedback]
    end

    test "get_feedback/1 returns the feedback with given id" do
      feedback = feedback_fixture()
      assert Orders.get_feedback(feedback.id) == feedback
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
