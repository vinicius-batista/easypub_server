defmodule EasypubWeb.Resolvers.MenuResolvers do
  @moduledoc """
  Resolvers for Menu
  """

  alias Easypub.Bars

  def create_menu_category(_, %{input: input}, _) do
    {:ok, input}
  end

  def get_menu_categories(_, %{bar_id: bar_id}, _) do
    menu_categories = Bars.list_menu_categories(bar_id)
    {:ok, menu_categories}
  end

  def get_menu_items(_, %{category_id: category_id}, _) do
    menu_items = Bars.list_menu_items(category_id)
    {:ok, menu_items}
  end
end
