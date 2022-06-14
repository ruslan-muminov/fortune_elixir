defmodule FortuneElixir.Storage do

  alias FortuneElixir.BookParser

  # FortuneElixir.Storage.init
  def init do
    :ets.new(:books, [:set, :protected, :named_table])

    books()
    |> Enum.map(fn book ->
      BookParser.parse_book_from_txt(book)
    end)
  end

  def random_book do
    [book] = books() |> Enum.take_random(1)
    book
  end

  # FortuneElixir.Storage.get_row(:pratchett_moris, 30, 20)
  def get_row(book, npage, nrow) do
    [{_, _, book_map}] = :ets.lookup(:books, book)

    book_map
    |> Map.get(npage)
    |> Map.get(nrow)
  end


  defp books do
    [
      :pratchett_moris
    ]
  end
end
