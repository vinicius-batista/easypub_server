defmodule EasypubWeb.MenuResolversTest do
  @moduledoc """
  Menu resolver tests
  """

  use EasypubWeb.ConnCase
  alias Easypub.{Accounts, Bars}

  setup do
    {:ok, user} =
      %{
        name: "some name",
        email: "email@email.com",
        password: "test",
        phone: "123123123",
        role: "bar_owner"
      }
      |> Accounts.create_user()

    {:ok, bar} =
      %{
        user_id: user.id,
        address: "some address",
        avatar: "some avatar",
        name: "some name",
        status: "some status"
      }
      |> Bars.create_bar()

    {:ok, menu_category} =
      %{bar_id: bar.id, name: "name"}
      |> Bars.create_menu_category()

    {:ok, menu_item} =
      %{
        category_id: menu_category.id,
        name: "some name",
        photo: "some photo",
        price: 11.11,
        description: "some description",
        waiting_time: "40min"
      }
      |> Bars.create_menu_item()

    {:ok,
     %{
       user: %Accounts.User{user | password: nil},
       menu_category: menu_category,
       menu_item: menu_item
     }}
  end

  test "update_menu_category should return updated category", %{
    conn: conn,
    user: user,
    menu_category: menu_category
  } do
    query = """
     mutation($input: UpdateMenuCategoryInput!) {
       updateMenuCategory(input:$input) {
         id,
         name
       }
     }
    """

    variables = %{
      input: %{
        id: menu_category.id,
        name: "some updated name"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("updateMenuCategory")

    assert response["name"] == "some updated name"
  end

  test "delete_menu_category should return success message", %{
    conn: conn,
    user: user,
    menu_category: menu_category
  } do
    query = """
     mutation($id: String!) {
       deleteMenuCategory(id:$id)
     }
    """

    variables = %{
      id: menu_category.id
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("deleteMenuCategory")

    assert response == "Categoria excluida com sucesso!"
  end

  test "update_menu_item should return updated item", %{
    conn: conn,
    user: user,
    menu_item: menu_item
  } do
    query = """
     mutation($input: UpdateMenuItemInput!) {
       updateMenuItem(input:$input) {
         id,
         name,
         description
       }
     }
    """

    variables = %{
      input: %{
        id: menu_item.id,
        name: "some updated name",
        description: "some updated description"
      }
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("updateMenuItem")

    assert response["name"] == "some updated name"
    assert response["description"] == "some updated description"
  end

  test "delete_menu_item should return success message", %{
    conn: conn,
    user: user,
    menu_item: menu_item
  } do
    query = """
     mutation($id: String!) {
       deleteMenuItem(id:$id)
     }
    """

    variables = %{
      id: menu_item.id
    }

    response =
      conn
      |> authenticate_user(user)
      |> graphql_query(query: query, variables: variables)
      |> get_query_data("deleteMenuItem")

    assert response == "Produto excluido com sucesso!"
  end
end
