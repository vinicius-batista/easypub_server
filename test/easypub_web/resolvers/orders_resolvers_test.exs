defmodule EasypubWeb.OrdersResolversTest do
  @moduledoc """
  Orders resolver tests
  """

  use EasypubWeb.ConnCase
  alias Easypub.{Accounts, BarsTest, OrdersTest}

  setup do
    {:ok, user} =
      %{
        name: "some name",
        email: "email@email.com",
        password: "test",
        phone: "123123123"
      }
      |> Accounts.create_user()

    table = BarsTest.table_fixture()
    menu_item = BarsTest.menu_item_fixture()
    order = OrdersTest.order_fixture()

    {:ok,
     %{
       user: %Accounts.User{user | password: nil},
       table: table,
       menu_item: menu_item,
       order: order
     }}
  end

  test "add_item_to_order should return order_item created", %{
    conn: conn,
    user: user,
    table: table,
    menu_item: menu_item
  } do
    query = """
    mutation($input:AddItemInput!) {
      addItemToOrder(input:$input){
        id,
        quantity,
        note
      }
    }
    """

    variables = %{
      input: %{
        table_id: table.id,
        quantity: 1,
        item_id: menu_item.id,
        note: "some note"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("addItemToOrder")

    assert response["quantity"] == 1
    assert response["note"] == "some note"
  end

  test "close_order should return order closed", %{
    conn: conn,
    order: order
  } do
    query = """
    mutation($orderId:String!) {
      closeOrder(orderId:$orderId) {
        id,
        status
      }
    }
    """

    variables = %{
      orderId: order.id
    }

    user = Accounts.get_user!(order.user_id)

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("closeOrder")

    assert response["status"] == "fechado"
    assert response["id"] == order.id
  end
end
