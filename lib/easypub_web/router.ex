defmodule EasypubWeb.Router do
  use EasypubWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EasypubWeb do
    pipe_through :api
  end
end
