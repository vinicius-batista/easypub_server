defmodule EasypubWeb.Helpers.BuildLoader do
  @moduledoc """
  Configure Dataloader for Graphql
  """
  import Ecto.Query, warn: false
  alias Easypub.Accounts.User
  alias Easypub.Bars.{Bar, MenuCategory, MenuItem, Table}
  alias Easypub.Orders.{Order, OrderItem, Feedback}
  alias Dataloader.Ecto

  def build(ctx) do
    loader =
      sources()
      |> Enum.reduce(Dataloader.new(), &Dataloader.add_source(&2, &1, data()))

    Map.put(ctx, :loader, loader)
  end

  defp sources do
    [
      User,
      Bar,
      MenuCategory,
      MenuItem,
      Table,
      Order,
      OrderItem,
      Feedback
    ]
  end

  defp data do
    Ecto.new(Easypub.Repo, query: &query/2)
  end

  defp query(MenuCategory, _params) do
    from(menu_category in MenuCategory,
      order_by: menu_category.inserted_at
    )
  end

  defp query(MenuItem, _params) do
    from(menu_item in MenuItem,
      order_by: menu_item.inserted_at
    )
  end

  defp query(queryable, _params) do
    queryable
  end
end
