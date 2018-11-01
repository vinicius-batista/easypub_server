defmodule Easypub.Bars do
  @moduledoc """
  The Bars context.
  """

  import Ecto.Query, warn: false
  alias Easypub.Repo

  alias Easypub.Bars.Bar

  defdelegate authorize(action, user, params), to: __MODULE__.Policy

  def list_bars(name, limit \\ 20, cursor \\ DateTime.utc_now()) do
    from(
      bar in Bar,
      where: like(bar.name, ^"%#{name}%") and bar.inserted_at < ^cursor,
      order_by: [desc: bar.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  def get_bar(id), do: Repo.get(Bar, id)

  def create_bar(attrs \\ %{}) do
    %Bar{}
    |> Bar.changeset(attrs)
    |> Repo.insert()
  end

  def update_bar(%Bar{} = bar, attrs) do
    bar
    |> Bar.changeset(attrs)
    |> Repo.update()
  end

  def delete_bar(%Bar{} = bar) do
    Repo.delete(bar)
  end

  alias Easypub.Bars.MenuCategory

  def list_menu_categories(bar_id) do
    from(
      menu_category in MenuCategory,
      where: menu_category.bar_id == ^bar_id
    )
    |> Repo.all()
  end

  def get_menu_category_with_bar(id) do
    bar_query = from(bar in Bar, select: [:id, :user_id])

    from(menu_category in MenuCategory,
      join: bar in assoc(menu_category, :bar),
      preload: [bar: ^bar_query],
      where: menu_category.id == ^id
    )
    |> Repo.one()
  end

  def create_menu_category(attrs \\ %{}) do
    %MenuCategory{}
    |> MenuCategory.changeset(attrs)
    |> Repo.insert()
  end

  def update_menu_category(%MenuCategory{} = menu_category, attrs) do
    menu_category
    |> MenuCategory.changeset(attrs)
    |> Repo.update()
  end

  def delete_menu_category(%MenuCategory{} = menu_category) do
    Repo.delete(menu_category)
  end

  alias Easypub.Bars.MenuItem

  def list_menu_items(category_id) do
    from(
      menu_item in MenuItem,
      where: menu_item.category_id == ^category_id,
      order_by: menu_item.inserted_at
    )
    |> Repo.all()
  end

  def get_menu_item(id), do: Repo.get(MenuItem, id)

  def get_menu_item_with_bar(id) do
    bar_query = from(bar in Bar, select: [:id, :user_id])

    from(
      menu_item in MenuItem,
      join: menu_category in assoc(menu_item, :menu_category),
      where: menu_item.id == ^id,
      preload: [menu_category: {menu_category, bar: ^bar_query}]
    )
    |> Repo.one()
  end

  def create_menu_item(attrs \\ %{}) do
    %MenuItem{}
    |> MenuItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_menu_item(%MenuItem{} = menu_item, attrs) do
    menu_item
    |> MenuItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_menu_item(%MenuItem{} = menu_item) do
    Repo.delete(menu_item)
  end

  alias Easypub.Bars.Table

  def create_table(attrs \\ %{}) do
    %Table{}
    |> Table.changeset(attrs)
    |> Repo.insert()
  end

  def get_table(id), do: Repo.get(Table, id, preload: :bar)

  def update_table(%Table{} = table, attrs) do
    table
    |> Table.changeset(attrs)
    |> Repo.update()
  end
end
