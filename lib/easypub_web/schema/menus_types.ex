defmodule EasypubWeb.Schema.MenusTypes do
  @moduledoc """
  Graphql schema related to Bars
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias EasypubWeb.Middlewares.{Authentication, HandleErrors}
  alias EasypubWeb.Resolvers.MenuResolvers
  alias Easypub.Bars.{MenuItem, Bar, MenuCategory}

  object :menu_category do
    field(:id, :id)
    field(:name, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:bar, :bar, resolve: dataloader(Bar))
    field(:menu_items, list_of(:menu_item), resolve: dataloader(MenuItem))
  end

  object :menu_item do
    field(:id, :id)
    field(:name, :string)
    field(:photo, :string)
    field(:price, :float)
    field(:description, :string)
    field(:waiting_time, :string)
    field(:inserted_at, :string)
    field(:updated_at, :string)
    field(:category_id, :string)
    field(:menu_category, :menu_category, resolve: dataloader(MenuCategory))
  end

  @desc "Input object for create_menu_category"
  input_object :create_menu_category_input do
    field(:name, non_null(:string))
    field(:bar_id, non_null(:string))
  end

  @desc "Input object for create_menu_item"
  input_object :create_menu_item_input do
    field(:name, non_null(:string))
    field(:category_id, non_null(:string))
    field(:photo, :string)
    field(:price, non_null(:float))
    field(:description, non_null(:string))
    field(:waiting_time, :string)
  end

  object :menus_mutations do
    field(:create_menu_category, :menu_category) do
      arg(:input, non_null(:create_menu_category_input))
      middleware(Authentication)
      resolve(&MenuResolvers.create_menu_category/3)
      middleware(HandleErrors)
    end

    field(:create_menu_item, :menu_item) do
      arg(:input, non_null(:create_menu_item_input))
      middleware(Authentication)
      resolve(&MenuResolvers.create_menu_item/3)
      middleware(HandleErrors)
    end
  end

  object :menus_queries do
    field(:menu_categories, list_of(:menu_category)) do
      arg(:bar_id, non_null(:string))
      middlewarre(Authentication)
      resolve(&MenuResolvers.get_menu_categories/3)
    end

    field(:menu_items, list_of(:menu_item)) do
      arg(:category_id, non_null(:string))
      middlewarre(Authentication)
      resolve(&MenuResolvers.get_menu_items/3)
    end

    field(:menu_item, :menu_item) do
      arg(:id, non_null(:string))
      middlewarre(Authentication)
      resolve(&MenuResolvers.get_menu_item/3)
    end
  end
end
