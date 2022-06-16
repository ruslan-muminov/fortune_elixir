defmodule FortuneElixir.MessageHandler do
  alias FortuneElixir.{Endpoint, Storage, UserProcess}

  require Logger
  
  def handle_message(conn) do
    {chat_id, text} = parse_conn_body(conn.body_params)
    Logger.info("body_params = #{inspect(conn.body_params)}")
    case String.split(text, ["/", " "], parts: 3) do
      ["", command] -> handle_command(command, "", conn)
      ["", command, tail] -> handle_command(command, tail, conn)
      [npage, nrow] -> handle_text({npage, nrow}, conn)
      _ -> handle_trash(conn, chat_id)
    end
  end

  def handle_command("start", _tail, conn) do
    %{"message" => %{"chat" => %{"id" => chat_id,
                                 "first_name" => _first_name,
                                 "username" => _username}}} = conn.body_params
    book = Storage.random_book
    pages_count = Storage.get_book_pages_count(book)

    send_message(chat_id, text(:start, {book, pages_count}))
    UserProcess.set(chat_id, book)
    Endpoint.call_send_resp(conn)
  end

  # def handle_command("help", _tail, conn) do
  #   %{"message" => %{"chat" => %{"id" => chat_id},
  #                    "text" => text}} = conn.body_params
  #   Nadia.send_message(chat_id, "Nikto tebe ne pomozhet")
  #   Endpoint.call_send_resp(conn)
  # end

  def handle_command(_command, _tail, conn) do
    %{"message" => %{"chat" => %{"id" => chat_id}}} = conn.body_params
    handle_trash(conn, chat_id)
  end

  def handle_text({npage, nrow}, conn) do
    %{"message" => %{"chat" => %{"id" => chat_id}}} = conn.body_params

    case {Integer.parse(npage), Integer.parse(nrow)} do
      {{npage_int, _}, {nrow_int, _}} ->
        maybe_send_result(conn, chat_id, {npage_int, nrow_int})
      _ ->
        handle_trash(conn, chat_id)
    end
  end

  def handle_trash(conn, chat_id) do
    send_message(chat_id, text(:trash, 1))
    UserProcess.remove(chat_id)
    Endpoint.call_send_resp(conn)
  end


  defp maybe_send_result(conn, chat_id, {npage_int, nrow_int}) do
    case UserProcess.lookup(chat_id) do
      nil -> handle_trash(conn, chat_id)
      book ->
        case Storage.get_row(book, npage_int, nrow_int) do
          {:ok, text} ->
            send_message(chat_id, text)
            UserProcess.remove(chat_id)
            Endpoint.call_send_resp(conn)
          {:error, _} ->
            handle_trash(conn, chat_id)
        end
    end
  end

  defp parse_conn_body(%{"message" => %{"chat" => %{"id" => chat_id}, "text" => text}}), do: {chat_id, text}
  defp parse_conn_body(%{"message" => %{"chat" => %{"id" => chat_id}, "caption" => caption}}), do: {chat_id, caption}

  def text(:start, {book, pages_count}), do: "Вам досталась книга <<#{Storage.book_name(book)}>>. Страниц: #{pages_count}. Строк на странице: 30. Укажите страницу и строчку в следующем формате:\n'<страница> <строчка>'"
  def text(:trash, _), do: "Мы тут по книжкам гадаем. Напишите '/start', чтобы начать"

  defp send_message(chat_id, text) do
    :fortune_elixir
    |> Application.get_env(:bot_token)
    |> Telegram.Api.request("sendMessage", chat_id: chat_id, text: text, disable_notification: true)
  end
end
