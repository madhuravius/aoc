defmodule Cafeteria.Core do
  @type fresh_ingredients_ranges() :: list(list(number))

  @spec parse_list(input :: String.t()) ::
          fresh_ingredients_ranges
  def parse_list(input) do
    [top, _] =
      input
      |> String.trim()
      |> String.split("\n\n")

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
        |> elem(0)
      end)
    end)
  end

  @spec compute_fresh(ranges :: fresh_ingredients_ranges) :: number
  def compute_fresh(ranges) do
    ranges
    |> Enum.sort()
    |> Enum.reduce([], fn [lower, upper], acc ->
      case acc do
        [] -> [[lower, upper]]
        [[prev_lower, prev_upper] | rest] when lower <= prev_upper + 1 ->
          [[prev_lower, max(upper, prev_upper)] | rest]
        _ -> [[lower, upper] | acc]
      end
    end)
    |> Enum.reduce(0, fn [lower, upper], count ->
      count + (upper - lower + 1)
    end)
  end
end
