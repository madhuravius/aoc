defmodule Cafeteria.Core do
  @type fresh_ingredients_ranges() :: list(list(number))
  @type ingredients_ids() :: list(number)

  # construct 2d array out of the input data, separated by new lines
  @spec parse_list(input :: String.t()) ::
          {:ok, {fresh_ingredients_ranges, ingredients_ids}} | {:error, term}
  def parse_list(input) do
    [top, bottom] =
      input
      |> String.trim()
      |> String.split("\n\n")

    ranges =
      top
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn letters ->
        letters
        |> String.trim()
        |> String.split("-", trim: true)
        |> Enum.map(fn letter ->
          letter
          |> String.trim()
          |> Integer.parse(10)
        end)
      end)

    ids =
      bottom
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn id ->
        id
        |> String.trim()
        |> Integer.parse(10)
      end)

    {:ok, {ranges, ids}}
  end

  @spec compute_fresh({ranges :: fresh_ingredients_ranges, ids :: ingredients_ids}) :: number
  def compute_fresh({ranges, ids}) do
    ids
    |> Enum.map(fn id ->
      ranges
      |> Enum.map(fn [lower, upper] ->
        id >= lower && id <= upper
      end)
      |> Enum.any?()
    end)
    |> Enum.filter(fn is_fresh -> is_fresh end)
    |> Enum.count()
  end
end
