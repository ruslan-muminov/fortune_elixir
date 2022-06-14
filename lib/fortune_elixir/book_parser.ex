defmodule FortuneElixir.BookParser do
  @str_limit 50
  @page_limit 30
  @books_folder "priv/books/"

  # {pages_count, result} = FortuneElixir.BookParser.test
  def test do
    "priv/books/pratchett_moris.txt"
    |> File.stream!()
    |> Stream.map(&String.split/1)
    |> Enum.concat
    |> make_pages
  end

  def parse_book_from_txt(book) do
    filename = @books_folder <> book <> ".txt"

    {pages_count, book_map} =
      filename
      |> File.stream!()
      |> Stream.map(&String.split/1)
      |> Enum.concat
      |> make_pages

    :ets.insert(:books, {book, pages_count, book_map})
  end

  # second param:
  #   {letters_in_row_counter::int, rows_in_page_counter::int, rows_sum::int,
  #    row::string, page::map(), result_struct::map()}
  def make_pages(words), do: make_pages(words, {0, 0, 0, "", %{}, %{}})
  def make_pages([], {_, rows_in_page, sum, row, page, result}) do
    {sum + 1, Map.put(result, sum + 1, Map.put(page, rows_in_page + 1, row))}
  end
  def make_pages([word | rest_words] = words, {letters_in_row, rows_in_page, sum, row, page, result}) do
    cond do
      rows_in_page == @page_limit ->
        new_sum = sum + 1
        make_pages(words, {letters_in_row, 0, new_sum, row, %{}, Map.put(result, new_sum, page)})
      letters_in_row + String.length(word) + 1 > @str_limit ->
        new_rows_in_page = rows_in_page + 1
        make_pages(words, {0, new_rows_in_page, sum, "", Map.put(page, new_rows_in_page, row), result})
      letters_in_row == 0 ->
        make_pages(rest_words, {letters_in_row + String.length(word), rows_in_page, sum, word, page, result})
      true ->
        make_pages(rest_words, {letters_in_row + String.length(word) + 1, rows_in_page, sum, row <> " " <> word, page, result})
    end
  end
end
