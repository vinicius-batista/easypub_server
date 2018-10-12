defmodule Easypub.Bars.Policy do
  @moduledoc """
  Policy rules for Bars
  """

  @behaviour Bodyguard.Policy
  alias Easypub.Accounts.User
  alias Easypub.Bars.{Bar}

  # Admin users can do anything
  def authorize(_, %User{role: "admin"}, _), do: true

  def authorize(:create_bar, %User{role: "bar_owner"}, _), do: true
  def authorize(:update_bar, %User{role: "bar_owner", id: user_id}, %{user_id: user_id}), do: true
  def authorize(:delete_bar, %User{role: "bar_owner", id: user_id}, %{user_id: user_id}), do: true

  def authorize(:create_menu_category, %User{role: "bar_owner", id: user_id}, %Bar{
        user_id: user_id
      }),
      do: true

  def authorize(:create_menu_item, %User{role: "bar_owner", id: user_id}, %Bar{user_id: user_id}),
    do: true

  # TODO: UPDATE AND DELETE
  # def authorize(:update_menu_category, %User{id: user_id}, %{user_id: user_id}), do: true
  # def authorize(:update_menu_item, %User{id: user_id}, %{user_id: user_id}), do: true

  # def authorize(:delete_menu_category, %User{id: user_id}, %{user_id: user_id}), do: true
  # def authorize(:delete_menu_item, %User{id: user_id}, %{user_id: user_id}), do: true

  def authorize(:create_table, %User{role: "bar_owner", id: user_id}, %Bar{user_id: user_id}),
    do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
