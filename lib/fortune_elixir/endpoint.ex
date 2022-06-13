defmodule FortuneElixir.Endpoint do
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
    %{"message" => %{"chat" => %{"id" => chat_id}, "text" => text}} = conn.body_params

    :fortune_elixir
    |> Application.get_env(:bot_token)
    |> Telegram.Api.request("sendMessage", chat_id: chat_id, text: text, disable_notification: true)

    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "ooops... Nothing there :(")
  end

  # def call_send_resp(conn) do
  #   send_resp(conn, 200, "")
  # end
end
