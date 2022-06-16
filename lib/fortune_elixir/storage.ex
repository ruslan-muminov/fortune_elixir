defmodule FortuneElixir.Storage do
  alias FortuneElixir.BookParser

  @books_table :books

  # FortuneElixir.Storage.init
  def init do
    :ets.new(@books_table, [:set, :protected, :named_table])

    Enum.map(books(), fn book ->
      BookParser.parse_book_from_txt(book)
    end)
  end

  def random_book do
    [book] = books() |> Enum.take_random(1)
    book
  end

  def get_book_pages_count(book) do
    [{_, pages_count, _}] = :ets.lookup(@books_table, book)
    pages_count
  end

  # FortuneElixir.Storage.get_row("pratchett_moris", 30, 20)
  def get_row(book, npage, nrow) do
    [{_, pages_count, book_map}] = :ets.lookup(@books_table, book)

    if npage <= 0 or npage > pages_count or nrow <= 0 or nrow > 30 do
      {:error, :incorrect_params}
    else
      {:ok, book_map |> Map.get(npage) |> Map.get(nrow)}
    end
  end

  def book_name("pratchett_moris"), do: "Терри Пратчетт. Изумительный Морис и его учёные грызуны"
  # def book_name("elinek_pohot"), do: "Эльфрида Елинек. Похоть"
  def book_name("tolstoi_voina"), do: "Лев Толстой. Война и мир"
  def book_name("bible"), do: "Библия"
  def book_name("pushkin_evgenii"), do: "Александр Пушкин. Евгений Онегин"
  def book_name("tolstoi_anna"), do: "Лев Толстой. Анна Каренина"
  def book_name("defo_robinzon"), do: "Данниель Дефо. Робинзон Крузо"
  def book_name("zamyatin_my"), do: "Евгений Замятин. Мы"
  def book_name("duma_graf"), do: "Александр Дюма. Граф Монте Кристо"
  def book_name("dostoevskiy_idiot"), do: "Федор Достоевский. Идиот"
  def book_name("gogol_dushi"), do: "Василий Гоголь. Мертвые души"
  def book_name("dostoevskiy_prestuplenie"), do: "Федор Достоевский. Преступление и наказание"


  defp books do
    [
      "pratchett_moris", # Терри Пратчетт. Изумительный Морис и его учёные грызуны
      # "duglas_avtostopom", # Дуглас Адамс. Автостопом по галактике
      # "elinek_pohot", # Эльфрида Елинек. Похоть
      # "tolstoi_voina", # Лев Толстой. Война и мир 
      # "vonnegut_sireni" # Курт Воннегут. Сирены титана
      "bible", # Библия
      "pushkin_evgenii", # Александр Пушкин. Евгений Онегин
      "tolstoi_anna", # Лев Толстой. Анна Каренина
      "defo_robinzon", # Данниель Дефо. Робинзон Крузо
      "zamyatin_my", # Евгений Замятин. Мы
      "duma_graf", # Александр Дюма. Граф Монте Кристо
      "dostoevskiy_idiot", # Федор Достоевский. Идиот
      "gogol_dushi", # Василий Гоголь. Мертвые души
      "dostoevskiy_prestuplenie" # Федор Достоевский. Преступление и наказание
    ]
  end
end
