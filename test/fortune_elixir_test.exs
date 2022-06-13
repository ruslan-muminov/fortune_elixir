defmodule FortuneElixirTest do
  use ExUnit.Case
  doctest FortuneElixir

  test "greets the world" do
    assert FortuneElixir.hello() == :world
  end
end
