defmodule Redirex.Shortener do
  @lowercase_range ?a..?z |> Enum.to_list()
  # @uppercase_range ?A..?Z |> Enum.to_list()
  @number_range ?0..?9 |> Enum.to_list()

  @allchar @lowercase_range ++ @number_range

  def generate_random(length) do
    for _ <- 1..length do
      generate_random_char()
    end
    |> to_string()
  end

  def generate_random_char do
    @allchar |> Enum.random()
  end

  def generate_random_unique(length) do
    res = generate_random(length)

    case Redirex.Store.get(res) do
      nil -> res
      _ -> generate_random(length)
    end
  end
end
