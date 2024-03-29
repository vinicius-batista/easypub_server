defmodule EasypubWeb.Resolvers.BarsResolvers do
  @moduledoc """
    Resolvers for Bars
  """
  alias Easypub.Bars

  def create_bar(_, %{input: input}, %{context: %{current_user: current_user}}) do
    attrs =
      %{user_id: current_user.id}
      |> Enum.into(input)

    with :ok <- Bodyguard.permit(Bars, :create_bar, current_user), do: Bars.create_bar(attrs)
  end

  def update_bar(_, %{input: input}, %{context: %{current_user: current_user}}) do
    bar = Bars.get_bar(input.id)

    with :ok <- Bodyguard.permit(Bars, :update_bar, current_user, bar) do
      bar
      |> Bars.update_bar(input)
    end
  end

  def delete_bar(_, %{id: id}, %{context: %{current_user: current_user}}) do
    bar = Bars.get_bar(id)

    with :ok <- Bodyguard.permit(Bars, :delete_bar, current_user, bar) do
      bar
      |> Bars.delete_bar()
    end
  end

  def get_bars(_, %{name: name, cursor: cursor, limit: limit}, _) do
    bars = Bars.list_bars(name, limit, cursor)
    {:ok, bars}
  end

  def get_bar(_, %{id: id}, _) do
    case Bars.get_bar(id) do
      nil -> {:error, :not_found}
      bar -> {:ok, bar}
    end
  end

  def create_table(_, %{input: input}, %{context: %{current_user: current_user}}) do
    bar = Bars.get_bar(input.bar_id)

    with :ok <- Bodyguard.permit(Bars, :create_table, current_user, bar),
         do: Bars.create_table(input)
  end

  def update_table(_, %{input: input}, %{context: %{current_user: current_user}}) do
    table = Bars.get_table(input.id)

    with :ok <- Bodyguard.permit(Bars, :update_table, current_user, table.bar) do
      table
      |> Bars.update_table(input)
    end
  end

  def delete_table(_, %{id: id}, %{context: %{current_user: current_user}}) do
    table = Bars.get_table(id)

    with :ok <- Bodyguard.permit(Bars, :delete_table, current_user, table.bar) do
      Bars.delete_table(table)
    end
  end
end
