defmodule EasypubWeb.Schema do
  @moduledoc """
  Graphql Schema
  """
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  query do
    field :user, :string do
      resolve(fn _, _, _ -> "ola" end)
    end
  end
end
