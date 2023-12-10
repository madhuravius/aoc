defmodule CamelCards.CLI do
  # https://adventofcode.com/2023/day/7#part2

  def main(args \\ []) do
    if Kernel.length(args) == 0 do
      raise "Unable to process as no file path provided, needs to be first positional argument"
    end

    file_name = List.first(args)
    IO.puts("Using file for input: #{file_name}")

    case File.read(file_name) do
      {:ok, body} ->
        score = CamelCards.Core.compute_score_for_input(body)
        IO.puts("Total score: #{score}")

      {:error, reason} ->
        IO.puts("Error reading the file: #{file_name} was not read for reason: #{reason}!")
    end
  end
end
