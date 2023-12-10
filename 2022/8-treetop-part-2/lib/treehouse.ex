defmodule Treehouse.CLI do
  # https://adventofcode.com/2022/day/8#part2

  def main(args \\ []) do
    if Kernel.length(args) == 0 do
      raise "Unable to process as no file path provided, needs to be first positional argument"
    end

    file_name = List.first(args)
    IO.puts("Using file for input: #{file_name}")

    case File.read(file_name) do
      {:ok, body} ->
        maximum_distance_product =
          body
          |> Treehouse.Core.parse_tree_cover_data()
          |> Treehouse.Core.maximum_distance_visible_product()

        IO.puts("Total trees visible: #{maximum_distance_product}")

      {:error, reason} ->
        IO.puts("Error reading the file: #{file_name} was not read for reason: #{reason}!")
    end
  end
end
