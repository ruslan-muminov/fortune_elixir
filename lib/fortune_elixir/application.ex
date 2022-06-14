defmodule FortuneElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Plug.Cowboy.child_spec(
      #   Application.get_env(:fortune_elixir, :plug_opts)
      # )
    ]

    FortuneElixir.Storage.init()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FortuneElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
