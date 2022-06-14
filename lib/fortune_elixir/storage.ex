defmodule FortuneElixir.Storage do
  alias FortuneElixir.BookParser

  @books_db :books

  # FortuneElixir.Storage.init
  def init do
    :ets.new(@books_db, [:set, :protected, :named_table])

    Enum.map(books(), fn book ->
      BookParser.parse_book_from_txt(book)
    end)
  end

  def random_book do
    [book] = books() |> Enum.take_random(1)
    book
  end

  # FortuneElixir.Storage.get_row("pratchett_moris", 30, 20)
  def get_row(book, npage, nrow) do
    [{_, _, book_map}] = :ets.lookup(@books_db, book)

    book_map
    |> Map.get(npage)
    |> Map.get(nrow)
  end


  defp books do
    [
      "pratchett_moris", # Терри Пратчетт. Изумительный Морис и его учёные грызуны
      # "duglas_avtostopom", # Дуглас Адамс. Автостопом по галактике
      "elinek_pohot", # Эльфрида Елинек. Похоть
      "tolstoi_voina" # Лев Толстой. Война и мир 
      # "vonnegut_sireni" # Курт Воннегут. Сирены титана
    ]
  end
end
