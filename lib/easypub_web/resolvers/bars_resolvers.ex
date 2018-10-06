defmodule EasypubWeb.Resolvers.BarsResolvers do
  @moduledoc """
    Resolvers for Bars
  """
  alias Easypub.Bars

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
end
