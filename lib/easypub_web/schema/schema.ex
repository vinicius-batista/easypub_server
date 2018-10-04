defmodule EasypubWeb.Schema do
  @moduledoc """
  Graphql Schema
  """
  use Absinthe.Schema
  alias EasypubWeb.Schema.AccountsTypes

  import_types(Absinthe.Type.Custom)
  import_types(AccountsTypes)

  query do
    import_fields(:accounts_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
  end
end
