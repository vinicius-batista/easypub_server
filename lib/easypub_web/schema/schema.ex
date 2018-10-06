defmodule EasypubWeb.Schema do
  @moduledoc """
  Graphql Schema
  """
  use Absinthe.Schema
  alias EasypubWeb.Schema.{AccountsTypes, BarsTypes, MenusTypes}

  import_types(Absinthe.Type.Custom)
  import_types(AccountsTypes)
  import_types(BarsTypes)
  import_types(MenusTypes)

  query do
    import_fields(:accounts_queries)
    import_fields(:bars_queries)
    import_fields(:menus_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
    import_field(:menu_mutations)
  end
end
