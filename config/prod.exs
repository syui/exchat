# This config is For example on Heroku
# You should add MIX_ENV=sample on heroku to use this config
use Mix.Config

config :exchat, Exchat.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("BASE_URL"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :exchat, Exchat.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 8
config :exchat, Exchat.User, jwt_secret: System.get_env("JWT_SECRET")

#config :exchat, Exchat.Mailer,
#  adapter: Bamboo.SMTPAdapter,
#  server: "smtp.gmail.com",
#  port: 587,
#  username: System.get_env("GMAIL"),
#  password: System.get_env("GMAIL_APP_PASS"),
#  tls: :if_available, # can be `:always` or `:never`
#  ssl: false, # can be `true`
#  retries: 1

config :exchat, Exchat.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.get_env("MAILGUN_API_KEY"),
  domain: System.get_env("MAILGUN_URL")

