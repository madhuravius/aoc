defmodule Cafeteria.CLI do
  # https://adventofcode.com/2025/day/5

  def main(args \\ []) do
    if Kernel.length(args) == 0 do
      raise "Unable to process as no file path provided, needs to be first positional argument"
    end

    file_name = List.first(args)
    IO.puts("Using file for input: #{file_name}")

    case File.read(file_name) do
      {:ok, body} ->
        {_, {list, ids}} =
          body
          |> Cafeteria.Core.parse_list()

        fresh = Cafeteria.Core.compute_fresh({list, ids})
        IO.puts("Total IDs that are fresh: #{fresh}")

      {:error, reason} ->
        IO.puts("Error reading the file: #{file_name} was not read for reason: #{reason}!")
    end
  end
end
