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

  @spec generate_antinodes_from_source_pairs_to_edge(antinode_source_pairs, number, number) ::
          list({number, number})
  def generate_antinodes_from_source_pairs_to_edge(antinode_source_pairs, x, y) do
    # combine complete result
    antinode_source_pairs
    |> Enum.map(fn {{{row1, col1}, {row2, col2}}, _} ->
      left = recurse_to_edge({row1, col1}, {row2 - row1, col2 - col1}, x, y, -1)
      right = recurse_to_edge({row2, col2}, {row2 - row1, col2 - col1}, x, y, 1)
      left ++ right
    end)
    |> List.flatten()
  end

  @spec recurse_to_edge({number, number}, {number, number}, number, number, integer) ::
          list({number, number})
  defp recurse_to_edge({x, y}, {dx, dy}, x_limit, y_limit, direction) do
    new_x = x + direction * dx
    new_y = y + direction * dy

    if new_x < 0 or new_x > x_limit or new_y < 0 or new_y > y_limit do
      []
    else
      [{new_x, new_y} | recurse_to_edge({new_x, new_y}, {dx, dy}, x_limit, y_limit, direction)]
    end
  end

  @spec generate_antinodes_from_source_pairs(antinode_source_pairs, number, number) ::
          list({number, number})
  def generate_antinodes_from_source_pairs(antinode_source_pairs, _, _) do
    # combine complete result
    antinode_source_pairs
    |> Enum.map(fn {{{row1, col1}, {row2, col2}}, _} ->
      [{row1 - (row2 - row1), col1 - (col2 - col1)}, {row2 + (row2 - row1), col2 + (col2 - col1)}]
    end)
    |> List.flatten()
  end

  @spec plot_antinodes_form_source_pairs(
          input :: map_data,
          antinodes :: list({number, number}),
          list(String.t())
        ) ::
          map_data
  def plot_antinodes_form_source_pairs(input, antinodes, extra_characters_to_ignore) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      Enum.with_index(row)
      |> Enum.map(fn {cell, cell_index} ->
        if {row_index, cell_index} in antinodes &&
             Enum.at(Enum.at(input, row_index), cell_index) in (exclude_chars() ++
                                                                  extra_characters_to_ignore) do
          "#"
        else
          cell
        end
      end)
    end)
  end

  @spec sum_all_antinodes(input :: binary(), go_to_map_edge :: boolean()) :: number
  def sum_all_antinodes(input, go_to_map_edge) do
    map_data =
      input
      |> ResidentCollinearity.Core.parse_map()

    core_antinode_determination =
      if go_to_map_edge do
        &ResidentCollinearity.Core.generate_antinodes_from_source_pairs_to_edge/3
      else
        &ResidentCollinearity.Core.generate_antinodes_from_source_pairs/3
      end

    frequencies =
      map_data
      |> ResidentCollinearity.Core.filter_unique_frequencies()

    frequencies
    |> Enum.map(fn frequency ->
      antinodes =
        map_data
        |> ResidentCollinearity.Core.find_frequency_pairs(frequency)
        |> ResidentCollinearity.Core.map_antinodes_source_pairs()
        |> core_antinode_determination.(length(map_data), length(Enum.at(map_data, 0)))

      extra_characters_to_include =
        if go_to_map_edge do
          frequencies -- [frequency]
        else
          []
        end

      map_data
      |> ResidentCollinearity.Core.plot_antinodes_form_source_pairs(
        antinodes,
        extra_characters_to_include
      )
      |> Enum.with_index()
      |> Enum.map(fn {row, row_index} ->
        Enum.with_index(row)
        |> Enum.map(fn {cell, cell_index} ->
          if cell == frequency ||
               (cell == "#" &&
                  Enum.at(Enum.at(map_data, row_index), cell_index) in exclude_chars()) do
            {row_index, cell_index}
          else
            nil
          end
        end)
      end)
    end)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Enum.uniq()
    |> Kernel.length()
  end

  @spec exclude_chars() :: list(String.t())
  defp exclude_chars do
    ["."]
  end
end
