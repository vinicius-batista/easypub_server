# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :easypub,
  ecto_repos: [Easypub.Repo]

# Configures the endpoint
config :easypub, EasypubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/YwBx1TgTQVALlZulMa7HooocD3y/uN0w2dxjfg0Ba+Lpuk0DP8c90uvViUTQR8R",
  render_errors: [view: EasypubWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Easypub.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix, :json_library, Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Phoenix Generators
config :easypub, :generators, binary_id: true

# Configures gettext
config :gettext, :default_locale, "pt_BR"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
