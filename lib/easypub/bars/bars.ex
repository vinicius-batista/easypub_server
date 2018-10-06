defmodule Easypub.Bars do
  @moduledoc """
  The Bars context.
  """

  import Ecto.Query, warn: false
  alias Easypub.Repo

  alias Easypub.Bars.Bar

  @doc """
  Returns the list of bars.

  ## Examples

      iex> list_bars()
      [%Bar{}, ...]

  """
  def list_bars(name, limit \\ 20, cursor \\ DateTime.utc_now()) do
    from(
      bar in Bar,
      where: like(bar.name, ^"%#{name}%") and bar.inserted_at < ^cursor,
      order_by: [desc: bar.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc """
  Gets a single bar.

  Raises `Ecto.NoResultsError` if the Bar does not exist.

  ## Examples

      iex> get_bar!(123)
      %Bar{}

      iex> get_bar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bar(id), do: Repo.get(Bar, id)

  @doc """
  Creates a bar.

  ## Examples

      iex> create_bar(%{field: value})
      {:ok, %Bar{}}

      iex> create_bar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bar(attrs \\ %{}) do
    %Bar{}
    |> Bar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bar.

  ## Examples

      iex> update_bar(bar, %{field: new_value})
      {:ok, %Bar{}}

      iex> update_bar(bar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bar(%Bar{} = bar, attrs) do
    bar
    |> Bar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bar.

  ## Examples

      iex> delete_bar(bar)
      {:ok, %Bar{}}

      iex> delete_bar(bar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bar(%Bar{} = bar) do
    Repo.delete(bar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bar changes.

  ## Examples

      iex> change_bar(bar)
      %Ecto.Changeset{source: %Bar{}}

  """
  def change_bar(%Bar{} = bar) do
    Bar.changeset(bar, %{})
  end

  alias Easypub.Bars.MenuCategory

  @doc """
  Returns the list of menu_categories.

  ## Examples

      iex> list_menu_categories()
      [%MenuCategory{}, ...]

  """
  def list_menu_categories(bar_id) do
    from(
      menu_category in MenuCategory,
      where: menu_category.bar_id == ^bar_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single menu_category.

  Raises `Ecto.NoResultsError` if the Menu category does not exist.

  ## Examples

      iex> get_menu_category!(123)
      %MenuCategory{}

      iex> get_menu_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_menu_category!(id), do: Repo.get!(MenuCategory, id)

  @doc """
  Creates a menu_category.

  ## Examples

      iex> create_menu_category(%{field: value})
      {:ok, %MenuCategory{}}

      iex> create_menu_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_menu_category(attrs \\ %{}) do
    %MenuCategory{}
    |> MenuCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a menu_category.

  ## Examples

      iex> update_menu_category(menu_category, %{field: new_value})
      {:ok, %MenuCategory{}}

      iex> update_menu_category(menu_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_menu_category(%MenuCategory{} = menu_category, attrs) do
    menu_category
    |> MenuCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MenuCategory.

  ## Examples

      iex> delete_menu_category(menu_category)
      {:ok, %MenuCategory{}}

      iex> delete_menu_category(menu_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_menu_category(%MenuCategory{} = menu_category) do
    Repo.delete(menu_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking menu_category changes.

  ## Examples

      iex> change_menu_category(menu_category)
      %Ecto.Changeset{source: %MenuCategory{}}

  """
  def change_menu_category(%MenuCategory{} = menu_category) do
    MenuCategory.changeset(menu_category, %{})
  end

  alias Easypub.Bars.MenuItem

  @doc """
  Returns the list of menu_items.

  ## Examples

      iex> list_menu_items()
      [%MenuItem{}, ...]

  """
  def list_menu_items(category_id) do
    from(
      menu_item in MenuItem,
      where: menu_item.category_id == ^category_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single menu_item.

  Raises `Ecto.NoResultsError` if the Menu item does not exist.

  ## Examples

      iex> get_menu_item!(123)
      %MenuItem{}

      iex> get_menu_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_menu_item!(id), do: Repo.get!(MenuItem, id)

  @doc """
  Creates a menu_item.

  ## Examples

      iex> create_menu_item(%{field: value})
      {:ok, %MenuItem{}}

      iex> create_menu_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_menu_item(attrs \\ %{}) do
    %MenuItem{}
    |> MenuItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a menu_item.

  ## Examples

      iex> update_menu_item(menu_item, %{field: new_value})
      {:ok, %MenuItem{}}

      iex> update_menu_item(menu_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_menu_item(%MenuItem{} = menu_item, attrs) do
    menu_item
    |> MenuItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MenuItem.

  ## Examples

      iex> delete_menu_item(menu_item)
      {:ok, %MenuItem{}}

      iex> delete_menu_item(menu_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_menu_item(%MenuItem{} = menu_item) do
    Repo.delete(menu_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking menu_item changes.

  ## Examples

      iex> change_menu_item(menu_item)
      %Ecto.Changeset{source: %MenuItem{}}

  """
  def change_menu_item(%MenuItem{} = menu_item) do
    MenuItem.changeset(menu_item, %{})
  end
end
