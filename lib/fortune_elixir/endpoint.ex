defmodule FortuneElixir.Endpoint do
  alias FortuneElixir.MessageHandler

  use Plug.Router

  require Logger

  @request_token Application.get_env(:fortune_elixir, :request_token)

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)


  get "/#{@request_token}/ping" do
    send_resp(conn, 200, "pong!")
  end

  post "#{@request_token}/fortune" do
    MessageHandler.handle_message(conn)
  end

  match _ do
    send_resp(conn, 404, "ooops... Nothing there :(")
  end

  def call_send_resp(conn) do
    send_resp(conn, 200, "")
  end
end
