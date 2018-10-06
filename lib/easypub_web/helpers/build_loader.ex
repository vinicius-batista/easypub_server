defmodule EasypubWeb.Helpers.BuildLoader do
  @moduledoc """
  Configure Dataloader for Graphql
  """
  import Ecto.Query, warn: false
  alias Easypub.Accounts.User
  alias Easypub.Bars.{Bar, MenuCategory, MenuItem}
  alias Dataloader.Ecto

  def build(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(User, data())
      |> Dataloader.add_source(Bar, data())
      |> Dataloader.add_source(MenuCategory, data())
      |> Dataloader.add_source(MenuItem, data())

    Map.put(ctx, :loader, loader)
  end

  defp data do
    Ecto.new(Easypub.Repo, query: &query/2)
  end

  defp query(queryable, _params) do
    queryable
  end
end
