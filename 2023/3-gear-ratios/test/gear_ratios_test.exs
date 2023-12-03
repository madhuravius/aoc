defmodule GearRatiosTest do
  use ExUnit.Case
  require IEx

  test "parses the schematic to data" do
    result =
      test_engine_schematic()
      |> GearRatios.Core.parse_engine_schematic_to_engine_data()

    assert result == [
             ["4", "6", "7", ".", ".", "1", "1", "4", ".", "."],
             [".", ".", ".", "*", ".", ".", ".", ".", ".", "."],
             [".", ".", "3", "5", ".", ".", "6", "3", "3", "."],
             [".", ".", ".", ".", ".", ".", "#", ".", ".", "."],
             ["6", "1", "7", "*", ".", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", "+", ".", "5", "8", "."],
             [".", ".", "5", "9", "2", ".", ".", ".", ".", "."],
             [".", ".", ".", ".", ".", ".", "7", "5", "5", "."],
             [".", ".", ".", "$", ".", "*", ".", ".", ".", "."],
             [".", "6", "6", "4", ".", "5", "9", "8", ".", "."]
           ]
  end

  test "parses schematic and tries to generate array of engine parts" do
    result =
      test_engine_schematic()
      |> GearRatios.Core.parse_engine_schematic_to_engine_data()
      |> GearRatios.Core.find_engine_parts_from_engine_data()

    assert result == [
             %GearRatios.PossibleEnginePart{part_number: 467, x: 0, y: 0},
             %GearRatios.PossibleEnginePart{part_number: 114, x: 5, y: 0},
             %GearRatios.PossibleEnginePart{part_number: 35, x: 2, y: 2},
             %GearRatios.PossibleEnginePart{part_number: 633, x: 6, y: 2},
             %GearRatios.PossibleEnginePart{part_number: 617, x: 0, y: 4},
             %GearRatios.PossibleEnginePart{part_number: 58, x: 7, y: 5},
             %GearRatios.PossibleEnginePart{part_number: 592, x: 2, y: 6},
             %GearRatios.PossibleEnginePart{part_number: 755, x: 6, y: 7},
             %GearRatios.PossibleEnginePart{part_number: 664, x: 1, y: 9},
             %GearRatios.PossibleEnginePart{part_number: 598, x: 5, y: 9}
           ]
  end

  test "parses schematic and tries generates array of engine symbols" do
    result =
      test_engine_schematic()
      |> GearRatios.Core.parse_engine_schematic_to_engine_data()
      |> GearRatios.Core.find_engine_symbols_from_engine_data()

    assert result == [
             %GearRatios.EngineSymbol{symbol: "*", x: 3, y: 1},
             %GearRatios.EngineSymbol{symbol: "#", x: 6, y: 3},
             %GearRatios.EngineSymbol{symbol: "*", x: 3, y: 4},
             %GearRatios.EngineSymbol{symbol: "+", x: 5, y: 5},
             %GearRatios.EngineSymbol{symbol: "$", x: 3, y: 8},
             %GearRatios.EngineSymbol{symbol: "*", x: 5, y: 8}
           ]
  end

  test "engine part is found to be adjacent to symbol" do
    engine_part = %GearRatios.PossibleEnginePart{part_number: 467, x: 0, y: 0}

    symbols = [
      %GearRatios.EngineSymbol{symbol: "*", x: 3, y: 1}
    ]

    assert GearRatios.Core.part_number_is_adjacent_to_symbol(engine_part, symbols) == true
  end

  test "engine part is not found to be adjacent to symbol" do
    engine_part = %GearRatios.PossibleEnginePart{part_number: 467, x: 0, y: 0}

    symbols = [
      %GearRatios.EngineSymbol{symbol: "#", x: 6, y: 3}
    ]

    assert GearRatios.Core.part_number_is_adjacent_to_symbol(engine_part, symbols) == false
  end

  test "engine part is not found to be adjacent to symbol (full list)" do
    engine_part = %GearRatios.PossibleEnginePart{part_number: 114, x: 5, y: 0}

    symbols = [
      %GearRatios.EngineSymbol{symbol: "*", x: 3, y: 1},
      %GearRatios.EngineSymbol{symbol: "#", x: 6, y: 3},
      %GearRatios.EngineSymbol{symbol: "*", x: 3, y: 4},
      %GearRatios.EngineSymbol{symbol: "+", x: 5, y: 5},
      %GearRatios.EngineSymbol{symbol: "$", x: 3, y: 8},
      %GearRatios.EngineSymbol{symbol: "*", x: 5, y: 8}
    ]

    assert GearRatios.Core.part_number_is_adjacent_to_symbol(engine_part, symbols) == false
  end

  test "sum_up_parts should be equal to expected value" do
    result =
      test_engine_schematic()
      |> GearRatios.Core.parse_engine_schematic_and_return_sum()

    assert result == 4361
  end

  defp test_engine_schematic do
    "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
  end
end
