defmodule EasypubWeb.Schema.BarsTypes do
  @moduledoc """
  Graphql schema related to Bars
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias EasypubWeb.Resolvers.BarsResolvers
  alias EasypubWeb.Middlewares.{Authentication}
  alias Easypub.Bars.MenuCategory

  @desc "Bars object"
  object :bar do
    field(:id, :id)
    field(:name, :string)
    field(:avatar, :string)
    field(:address, :string)
    field(:status, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:menu_categories, list_of(:menu_category), resolve: dataloader(MenuCategory))
  end

  object :bars_queries do
    field :bars, list_of(:bar) do
      arg(:name, non_null(:string))
      arg(:limit, :integer, default_value: 20)
      arg(:cursor, :string, default_value: DateTime.utc_now())
      middleware(Authentication)
      resolve(&BarsResolvers.get_bars/3)
    end

    field :bar, non_null(:bar) do
      arg(:id, non_null(:integer))
      middleware(Authentication)
      resolve(&BarsResolvers.get_bar/3)
    end
  end
end
