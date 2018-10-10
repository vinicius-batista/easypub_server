defmodule Easypub.Bars.Table do
  use Easypub.Schema
  import Ecto.Changeset

  alias Easypub.Bars.Bar

  schema "tables" do
    field(:number, :integer)

    belongs_to(:bar, Bar, foreign_key: :bar_id)
    timestamps()
  end

  @required_fields ~w(number bar_id)a
  @doc false
  def changeset(table, attrs) do
    table
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
