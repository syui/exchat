# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :exchat, Exchat.Endpoint,
  url: [host: System.get_env("HEROKU_URL")],
  root: Path.dirname(__DIR__),
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  debug_errors: false,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Exchat.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :exchat, ecto_repos: [Exchat.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :exchat, Exchat.Channel, default_channels: ["general", "random"]


#config :ravenx,
#  strategies: [
#    email: Ravenx.Strategy.Email,
#    slack: Ravenx.Strategy.Slack
#  ]
#
#config :ravenx,
#  config: Exchat.RavenxConfig
#  config :ravenx, :slack,
#    url: "https://hooks.slack.com/services/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",
#    icon: ":bird:"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

