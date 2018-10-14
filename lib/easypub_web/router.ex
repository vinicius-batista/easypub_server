defmodule EasypubWeb.Router do
  @moduledoc """
  Module for Router
  """
  use EasypubWeb, :router

  pipeline :graphql do
    plug(:accepts, ["json"])
    plug(EasypubWeb.Context)
  end

  scope "/" do
    pipe_through(:graphql)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: EasypubWeb.Schema,
      socket: EasypubWeb.UserSocket,
      interface: :advanced
    )

    forward("/graphql", Absinthe.Plug,
      schema: EasypubWeb.Schema,
      analyze_complexity: true,
      max_complexity: 250
    )
  end
end
