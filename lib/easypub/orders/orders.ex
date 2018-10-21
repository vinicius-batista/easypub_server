defmodule Easypub.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Easypub.Repo

  alias Easypub.Orders.Order

  defdelegate authorize(action, user, params), to: __MODULE__.Policy

  def add_item_to_order(attrs, user) do
    item_attrs = Map.take(attrs, [:quantity, :item_id, :note])

    case get_order_by(table_id: attrs.table_id, status: "aberto", user_id: user.id) do
      nil ->
        {:ok, order} = create_order(%{table_id: attrs.table_id, user_id: user.id})

        %{order_id: order.id}
        |> Enum.into(item_attrs)
        |> create_order_item()

      order ->
        %{order_id: order.id}
        |> Enum.into(item_attrs)
        |> create_order_item()
    end
  end

  def get_order_by(clauses) do
    Order
    |> Repo.get_by(clauses)
  end

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(user_id, limit \\ 20, cursor \\ DateTime.utc_now()) do
    from(
      order in Order,
      where: order.user_id == ^user_id and order.inserted_at < ^cursor,
      order_by: [desc: order.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  def get_order_with_table(id) do
    from(order in Order,
      join: table in assoc(order, :table),
      preload: [:table],
      where: order.id == ^id
    )
    |> Repo.one()
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order(id), do: Repo.get(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end

  alias Easypub.Orders.OrderItem

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItem)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OrderItem.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_order_item(order_item)
      %Ecto.Changeset{source: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item) do
    OrderItem.changeset(order_item, %{})
  end

  alias Easypub.Orders.Feedback

  @doc """
  Returns the list of feedbacks.

  ## Examples

      iex> list_feedbacks()
      [%Feedback{}, ...]

  """
  def list_feedbacks do
    Repo.all(Feedback)
  end

  @doc """
  Gets a single feedback.

  Raises `Ecto.NoResultsError` if the Feedback does not exist.

  ## Examples

      iex> get_feedback!(123)
      %Feedback{}

      iex> get_feedback!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feedback(id), do: Repo.get!(Feedback, id)

  def get_feedback_by(clauses \\ []), do: Repo.get_by(Feedback, clauses)

  @doc """
  Creates a feedback.

  ## Examples

      iex> create_feedback(%{field: value})
      {:ok, %Feedback{}}

      iex> create_feedback(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feedback(attrs \\ %{}) do
    %Feedback{}
    |> Feedback.changeset(attrs)
    |> Repo.insert()
  end
end
