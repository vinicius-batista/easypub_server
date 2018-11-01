defmodule Easypub.Orders.Policy do
  @moduledoc """
  Policy rules for Orders
  """

  @behaviour Bodyguard.Policy
  alias Easypub.Accounts.User

  # Admin users can do anything
  def authorize(_, %User{role: "admin"}, _), do: true

  def authorize(:close_order, %User{id: user_id}, %{user_id: user_id}), do: true
  def authorize(:get_order, %User{id: user_id}, %{user_id: user_id}), do: true
  def authorize(:active_orders, %User{id: user_id}, %{user_id: user_id}), do: true

  def authorize(:order_subscription_config, %User{id: user_id}, %{user_id: user_id}), do: true

  def authorize(:create_feedback, %User{id: user_id}, %{user_id: user_id}), do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
