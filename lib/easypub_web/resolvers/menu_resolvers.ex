defmodule EasypubWeb.Resolvers.MenuResolvers do
  @moduledoc """
  Resolvers for Menu
  """

  alias Easypub.Bars

  def create_menu_category(_, %{input: input}, %{context: %{current_user: current_user}}) do
    bar = Bars.get_bar(input.bar_id)

    with :ok <- Bodyguard.permit(Bars, :create_menu_category, current_user, bar) do
      Bars.create_menu_category(input)
    end
  end

  def create_menu_item(_, %{input: input}, %{context: %{current_user: current_user}}) do
    menu_category = Bars.get_menu_category_with_bar(input.category_id)

    with :ok <- Bodyguard.permit(Bars, :create_menu_item, current_user, menu_category.bar) do
      Bars.create_menu_item(input)
    end
  end

  def get_menu_categories(_, %{bar_id: bar_id}, _) do
    menu_categories = Bars.list_menu_categories(bar_id)
    {:ok, menu_categories}
  end

  def get_menu_items(_, %{category_id: category_id}, _) do
    menu_items = Bars.list_menu_items(category_id)
    {:ok, menu_items}
  end

  def get_menu_item(_, %{id: id}, _) do
    menu_item = Bars.get_menu_item(id)
    {:ok, menu_item}
  end

  def update_menu_category(_, %{input: input}, %{context: %{current_user: current_user}}) do
    %{bar: bar} = menu_category = Bars.get_menu_category_with_bar(input.id)

    with :ok <- Bodyguard.permit(Bars, :update_menu_category, current_user, bar) do
      Bars.update_menu_category(menu_category, input)
    end
  end

  def delete_menu_category(_, %{id: id}, %{context: %{current_user: current_user}}) do
    %{bar: bar} = menu_category = Bars.get_menu_category_with_bar(id)

    with :ok <- Bodyguard.permit(Bars, :delete_menu_category, current_user, bar) do
      {:ok, _} = Bars.delete_menu_category(menu_category)
      {:ok, "Categoria excluida com sucesso!"}
    end
  end

  def update_menu_item(_, %{input: input}, %{context: %{current_user: current_user}}) do
    %{menu_category: %{bar: bar}} = menu_item = Bars.get_menu_item_with_bar(input.id)

    with :ok <- Bodyguard.permit(Bars, :update_menu_item, current_user, bar) do
      Bars.update_menu_item(menu_item, input)
    end
  end

  def delete_menu_item(_, %{id: id}, %{context: %{current_user: current_user}}) do
    %{menu_category: %{bar: bar}} = menu_item = Bars.get_menu_item_with_bar(id)

    with :ok <- Bodyguard.permit(Bars, :delete_menu_item, current_user, bar) do
      {:ok, _} = Bars.delete_menu_item(menu_item)
      {:ok, "Produto excluido com sucesso!"}
    end
  end
end
