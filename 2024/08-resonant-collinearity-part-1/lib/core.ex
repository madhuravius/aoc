defmodule ResidentCollinearity.Core do
  @type map_data() :: list(list(number | String.t()))
  @type frequency_pairs() :: list({number, number})
  @type antinode_source_pairs() :: {{number, number}, {number, number}}

  @spec parse_map_and_return_count(input :: String.t()) :: number
  def parse_map_and_return_count(input) do
    input |> ResidentCollinearity.Core.parse_map()
    10
  end

  @spec parse_map(input :: String.t()) :: map_data
  def parse_map(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn letters -> String.split(letters, "", trim: true) end)
  end

  @spec filter_unique_frequencies(input :: map_data) :: list(String.t())
  def filter_unique_frequencies(input) do
    input
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.reject(&(&1 in exclude_chars()))
  end

  @spec filter_map_to_frequency(input :: map_data, frequency :: String.t()) :: map_data
  def filter_map_to_frequency(input, frequency) do
    input
    |> Enum.map(fn row ->
      Enum.map(row, fn cell ->
        if cell == frequency do
          cell
        else
          "."
        end
      end)
    end)
  end

  @spec find_frequency_pairs(input :: map_data, frequency :: String.t()) :: frequency_pairs
  def find_frequency_pairs(input, frequency) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, cell_index} ->
        if cell == frequency do
          {row_index, cell_index}
        end
      end)
    end)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  @spec map_antinodes_source_pairs(frequency_pairs) :: antinode_source_pairs
  def map_antinodes_source_pairs(frequency_pairs) do
    frequency_pairs
    |> Enum.flat_map(fn pair1 ->
      Enum.map(frequency_pairs, fn pair2 ->
        if pair1 != pair2 do
          sorted_pair = Enum.sort([pair1, pair2])
          {List.first(sorted_pair), List.last(sorted_pair)}
        end
      end)
    end)
    |> Enum.uniq()
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{}, fn pair -> {pair, true} end)
  end

  @spec generate_antinodes_from_source_pairs(antinode_source_pairs) :: list({number, number})
  def generate_antinodes_from_source_pairs(antinode_source_pairs) do
    antinode_source_pairs
    |> Enum.map(fn {{{row1, col1}, {row2, col2}}, _} ->
      [{row1 - (row2 - row1), col1 - (col2 - col1)}, {row2 + (row2 - row1), col2 + (col2 - col1)}]
    end)
    |> List.flatten()
  end

  @spec plot_antinodes_form_source_pairs(input :: map_data, antinodes :: list({number, number})) ::
          map_data
  def plot_antinodes_form_source_pairs(input, antinodes) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, cell_index} ->
        if {row_index, cell_index} in antinodes &&
             Enum.at(Enum.at(input, row_index), cell_index) in exclude_chars() do
          "#"
        else
          cell
        end
      end)
    end)
  end

  @spec sum_all_antinodes(input :: binary()) :: number
  def sum_all_antinodes(input) do
    map_data =
      input
      |> ResidentCollinearity.Core.parse_map()

    map_data
    |> ResidentCollinearity.Core.filter_unique_frequencies()
    |> Enum.map(fn frequency ->
      antinodes =
        map_data
        |> ResidentCollinearity.Core.find_frequency_pairs(frequency)
        |> ResidentCollinearity.Core.map_antinodes_source_pairs()
        |> ResidentCollinearity.Core.generate_antinodes_from_source_pairs()

      map_data
      |> ResidentCollinearity.Core.plot_antinodes_form_source_pairs(antinodes)
      |> Enum.with_index()
      |> Enum.map(fn {row, row_index} ->
        Enum.with_index(row)
        |> Enum.map(fn {cell, cell_index} ->
          if cell == "#" && Enum.at(Enum.at(map_data, row_index), cell_index) in exclude_chars() do
            1
          else
            0
          end
        end)
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  @spec exclude_chars() :: list(String.t())
  defp exclude_chars do
    ["."]
  end
end
