defmodule Easypub.Schema do
  @moduledoc """
  Custom ecto schema
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :naive_datetime_usec]
    end
  end
end
