defmodule GearRatios.CLI do
  # https://adventofcode.com/2023/day/3

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

      {:error, reason} ->
        IO.puts("Error reading the file: #{file_name} was not read for reason: #{reason}!")
    end
  end
end
