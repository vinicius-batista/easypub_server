defmodule EasypubWeb.Schema.BarsTypes do
  @moduledoc """
  Graphql schema related to Bars
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias EasypubWeb.Resolvers.BarsResolvers
  alias EasypubWeb.Middlewares.{Authentication, HandleErrors}
  alias Easypub.Bars.{MenuCategory, Bar}

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

  object :table do
    field(:id, :id)
    field(:number, :integer)
    field(:bar, :bar, resolve: dataloader(Bar))
  end

  input_object :create_bar_input do
    field(:name, non_null(:string))
    field(:avatar, :string)
    field(:address, non_null(:string))
  end

  input_object :update_bar_input do
    field(:id, non_null(:string))
    field(:name, :string)
    field(:avatar, :string)
    field(:address, :string)
    field(:status, :string)
  end

  input_object :create_table_input do
    field(:bar_id, non_null(:string))
    field(:number, non_null(:integer))
  end

  object :bars_mutations do
    field :create_bar, :bar do
      arg(:input, non_null(:create_bar_input))
      middleware(Authentication)
      resolve(&BarsResolvers.create_bar/3)
      middleware(HandleErrors)
    end

    field :update_bar, :bar do
      arg(:input, non_null(:update_bar_input))
      middleware(Authentication)
      resolve(&BarsResolvers.update_bar/3)
      middleware(HandleErrors)
    end

    field :delete_bar, :bar do
      arg(:id, non_null(:string))
      middleware(Authentication)
      resolve(&BarsResolvers.delete_bar/3)
      middleware(HandleErrors)
    end

    field :create_table, :table do
      arg(:input, non_null(:create_table_input))
      middleware(Authentication)
      resolve(&BarsResolvers.create_table/3)
      middleware(HandleErrors)
    end
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
      arg(:id, non_null(:string))
      middleware(Authentication)
      resolve(&BarsResolvers.get_bar/3)
    end
  end
end
