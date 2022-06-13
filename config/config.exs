import Config

config :fortune_elixir, :plug_opts,
  scheme: :https,
  plug: FortuneElixir.Endpoint,
  options: [port: 8443,
            otp_app: :fortune_elixir,
            keyfile: "priv/ssl/fortune.key",
            certfile: "priv/ssl/fortune.pem"]

# if File.exists?("./config/#{Mix.env()}.exs") do
#   import_config "#{Mix.env()}.exs"
# end

if File.exists?("./config/secret.exs") do
  import_config "secret.exs"
end
