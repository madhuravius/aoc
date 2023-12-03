defmodule GearRatios.CLI do
  @moduledoc """
  Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one 
  hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.

  The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly 
  two part numbers. Its gear ratio is the result of multiplying those two numbers together.

  This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs 
  to be replaced.

  Consider the same engine schematic again:

  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..

  In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. 
  The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent 
  to one part number.) Adding up all of the gear ratios produces 467835.
  """
  def main(args \\ []) do
    if Kernel.length(args) == 0 do
      raise "Unable to process as no file path provided, needs to be first positional argument"
    end

    file_name = List.first(args)
    IO.puts("Using file for input: #{file_name}")

    case File.read(file_name) do
      {:ok, body} ->
        sum =
          body
          |> GearRatios.Core.parse_engine_schematic_and_return_sum()

        IO.puts("Total sum: #{sum}")

        sum_of_gear_ratios =
          body
          |> GearRatios.Core.parse_engine_schematic_and_return_sum_gear_ratios()
        IO.puts("Total sum of gear ratios: #{sum_of_gear_ratios}")

      {:error, reason} ->
        IO.puts("Error reading the file: #{file_name} was not read for reason: #{reason}!")
    end
  end
end
