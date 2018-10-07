defmodule Easypub.BarsTest do
  use Easypub.DataCase

  alias Easypub.Bars

  describe "bars" do
    alias Easypub.Bars.Bar

    @valid_attrs %{
      address: "some address",
      avatar: "some avatar",
      name: "some name",
      status: "some status"
    }
    @update_attrs %{
      address: "some updated address",
      avatar: "some updated avatar",
      name: "some updated name",
      status: "some updated status"
    }
    @invalid_attrs %{address: nil, avatar: nil, name: nil, status: nil}

    def bar_fixture(attrs \\ %{}) do
      {:ok, bar} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bars.create_bar()

      bar
    end

    test "list_bars/0 returns all bars" do
      bar = bar_fixture()
      assert Bars.list_bars("some") == [bar]
    end

    test "get_bar/1 returns the bar with given id" do
      bar = bar_fixture()
      assert Bars.get_bar(bar.id) == bar
    end

    test "create_bar/1 with valid data creates a bar" do
      assert {:ok, %Bar{} = bar} = Bars.create_bar(@valid_attrs)
      assert bar.address == "some address"
      assert bar.avatar == "some avatar"
      assert bar.name == "some name"
      assert bar.status == "some status"
    end

    test "create_bar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bars.create_bar(@invalid_attrs)
    end

    test "update_bar/2 with valid data updates the bar" do
      bar = bar_fixture()
      assert {:ok, bar} = Bars.update_bar(bar, @update_attrs)
      assert %Bar{} = bar
      assert bar.address == "some updated address"
      assert bar.avatar == "some updated avatar"
      assert bar.name == "some updated name"
      assert bar.status == "some updated status"
    end

    test "update_bar/2 with invalid data returns error changeset" do
      bar = bar_fixture()
      assert {:error, %Ecto.Changeset{}} = Bars.update_bar(bar, @invalid_attrs)
      assert bar == Bars.get_bar(bar.id)
    end

    test "delete_bar/1 deletes the bar" do
      bar = bar_fixture()
      assert {:ok, %Bar{}} = Bars.delete_bar(bar)
      assert nil == Bars.get_bar(bar.id)
    end

    test "change_bar/1 returns a bar changeset" do
      bar = bar_fixture()
      assert %Ecto.Changeset{} = Bars.change_bar(bar)
    end
  end

  describe "menu_categories" do
    alias Easypub.Bars.MenuCategory

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def menu_category_fixture(attrs \\ %{}) do
      bar =
        %{
          address: "some address",
          avatar: "some avatar",
          name: "some name",
          status: "some status"
        }
        |> bar_fixture()

      {:ok, menu_category} =
        attrs
        |> Enum.into(%{bar_id: bar.id})
        |> Enum.into(@valid_attrs)
        |> Bars.create_menu_category()

      menu_category
    end

    test "list_menu_categories/0 returns all menu_categories" do
      menu_category = menu_category_fixture()
      assert Bars.list_menu_categories(menu_category.bar_id) == [menu_category]
    end

    test "get_menu_category!/1 returns the menu_category with given id" do
      menu_category = menu_category_fixture()
      assert Bars.get_menu_category!(menu_category.id) == menu_category
    end

    test "create_menu_category/1 with valid data creates a menu_category" do
      bar =
        %{
          address: "some address",
          avatar: "some avatar",
          name: "some name",
          status: "some status"
        }
        |> bar_fixture()

      attrs =
        %{bar_id: bar.id}
        |> Enum.into(@valid_attrs)

      assert {:ok, %MenuCategory{} = menu_category} = Bars.create_menu_category(attrs)
      assert menu_category.name == "some name"
    end

    test "create_menu_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bars.create_menu_category(@invalid_attrs)
    end

    test "update_menu_category/2 with valid data updates the menu_category" do
      menu_category = menu_category_fixture()
      assert {:ok, menu_category} = Bars.update_menu_category(menu_category, @update_attrs)
      assert %MenuCategory{} = menu_category
      assert menu_category.name == "some updated name"
    end

    test "update_menu_category/2 with invalid data returns error changeset" do
      menu_category = menu_category_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Bars.update_menu_category(menu_category, @invalid_attrs)

      assert menu_category == Bars.get_menu_category!(menu_category.id)
    end

    test "delete_menu_category/1 deletes the menu_category" do
      menu_category = menu_category_fixture()
      assert {:ok, %MenuCategory{}} = Bars.delete_menu_category(menu_category)
      assert_raise Ecto.NoResultsError, fn -> Bars.get_menu_category!(menu_category.id) end
    end

    test "change_menu_category/1 returns a menu_category changeset" do
      menu_category = menu_category_fixture()
      assert %Ecto.Changeset{} = Bars.change_menu_category(menu_category)
    end
  end

  describe "menu_items" do
    alias Easypub.Bars.MenuItem

    @valid_attrs %{
      name: "some name",
      photo: "some photo",
      price: 11.11,
      description: "some description",
      waiting_time: "40min"
    }
    @update_attrs %{
      name: "some updated name",
      photo: "some updated photo",
      price: 22.22,
      description: "some updated description",
      waiting_time: "60min"
    }
    @invalid_attrs %{name: nil, photo: nil, price: nil}

    def menu_item_fixture(attrs \\ %{}) do
      menu_category =
        %{name: "some category"}
        |> menu_category_fixture()

      {:ok, menu_item} =
        attrs
        |> Enum.into(%{category_id: menu_category.id})
        |> Enum.into(@valid_attrs)
        |> Bars.create_menu_item()

      menu_item
    end

    test "list_menu_items/0 returns all menu_items" do
      menu_item = menu_item_fixture()
      assert Bars.list_menu_items(menu_item.category_id) == [menu_item]
    end

    test "get_menu_item/1 returns the menu_item with given id" do
      menu_item = menu_item_fixture()
      assert Bars.get_menu_item(menu_item.id) == menu_item
    end

    test "create_menu_item/1 with valid data creates a menu_item" do
      menu_category =
        %{name: "some category"}
        |> menu_category_fixture()

      attrs =
        @valid_attrs
        |> Enum.into(%{category_id: menu_category.id})

      assert {:ok, %MenuItem{} = menu_item} = Bars.create_menu_item(attrs)
      assert menu_item.name == "some name"
      assert menu_item.price == Decimal.new(11.11)
      assert menu_item.photo == "some photo"
      assert menu_item.description == "some description"
      assert menu_item.waiting_time == "40min"
    end

    test "create_menu_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bars.create_menu_item(@invalid_attrs)
    end

    test "update_menu_item/2 with valid data updates the menu_item" do
      menu_item = menu_item_fixture()
      assert {:ok, menu_item} = Bars.update_menu_item(menu_item, @update_attrs)
      assert %MenuItem{} = menu_item
      assert menu_item.name == "some updated name"
      assert menu_item.photo == "some updated photo"
      assert menu_item.description == "some updated description"
      assert menu_item.price == Decimal.new(22.22)
      assert menu_item.waiting_time == "60min"
    end

    test "update_menu_item/2 with invalid data returns error changeset" do
      menu_item = menu_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Bars.update_menu_item(menu_item, @invalid_attrs)
      assert menu_item == Bars.get_menu_item(menu_item.id)
    end

    test "delete_menu_item/1 deletes the menu_item" do
      menu_item = menu_item_fixture()
      assert {:ok, %MenuItem{}} = Bars.delete_menu_item(menu_item)
      assert nil == Bars.get_menu_item(menu_item.id)
    end

    test "change_menu_item/1 returns a menu_item changeset" do
      menu_item = menu_item_fixture()
      assert %Ecto.Changeset{} = Bars.change_menu_item(menu_item)
    end
  end
end
