defmodule ResonantCollinearityTest do
  use ExUnit.Case
  require IEx

  test "parses the map to data" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.parse_map()

    assert result == [
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", "0", ".", ".", "."],
             [".", ".", ".", ".", ".", "0", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", "0", ".", ".", ".", "."],
             [".", ".", ".", ".", "0", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", "A", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", "A", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", "A", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]
           ]
  end

  test "filter_unique_frequencies" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.parse_map()
      |> ResidentCollinearity.Core.filter_unique_frequencies()

    assert result == ["0", "A"]
  end

  test "filter_map_to_frequency" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.parse_map()
      |> ResidentCollinearity.Core.filter_map_to_frequency("0")

    assert result == [
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", "0", ".", ".", "."],
             [".", ".", ".", ".", ".", "0", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", "0", ".", ".", ".", "."],
             [".", ".", ".", ".", "0", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]
           ]
  end

  test "find_frequency_pairs" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.parse_map()
      |> ResidentCollinearity.Core.find_frequency_pairs("0")

    assert result == [{1, 8}, {2, 5}, {3, 7}, {4, 4}]
  end

  test "map_antinodes_source_pairs" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.parse_map()
      |> ResidentCollinearity.Core.find_frequency_pairs("0")
      |> ResidentCollinearity.Core.map_antinodes_source_pairs()

    assert result == %{
             {{1, 8}, {2, 5}} => true,
             {{1, 8}, {3, 7}} => true,
             {{1, 8}, {4, 4}} => true,
             {{2, 5}, {3, 7}} => true,
             {{2, 5}, {4, 4}} => true,
             {{3, 7}, {4, 4}} => true
           }
  end

  test "generate_antinodes_from_source_pairs" do
    result =
      ResidentCollinearity.Core.generate_antinodes_from_source_pairs(%{
        {{1, 8}, {2, 5}} => true,
        {{2, 5}, {3, 7}} => true
      })

    assert result == [{0, 11}, {3, 2}, {1, 3}, {4, 9}]
  end

  test "plot_antinodes_form_source_pairs" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.parse_map()
      |> ResidentCollinearity.Core.plot_antinodes_form_source_pairs([
        {0, 11},
        {3, 2},
        {1, 3},
        {4, 9}
      ])

    assert result == [
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "#"],
             [".", ".", ".", "#", ".", ".", ".", ".", "0", ".", ".", "."],
             [".", ".", ".", ".", ".", "0", ".", ".", ".", ".", ".", "."],
             [".", ".", "#", ".", ".", ".", ".", "0", ".", ".", ".", "."],
             [".", ".", ".", ".", "0", ".", ".", ".", ".", "#", ".", "."],
             [".", ".", ".", ".", ".", ".", "A", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", "A", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", "A", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]
           ]
  end

  test "plot_antinodes_from_all_source_pairs" do
    result =
      test_map_data()
      |> ResidentCollinearity.Core.sum_all_antinodes()

    assert result == 14
  end

  defp test_map_data do
    "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"
  end
end
