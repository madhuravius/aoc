defmodule GearRatios.PossibleEnginePart do
  defstruct [:part_number, :x, :y]

  @type t :: %__MODULE__{
          part_number: number,
          x: number,
          y: number
        }
end

defmodule GearRatios.EngineSymbol do
  defstruct [:symbol, :x, :y]

  @type t :: %__MODULE__{
          symbol: String.t(),
          x: number,
          y: number
        }
end

defmodule GearRatios.Core do
  alias GearRatios.EngineSymbol
  @spec symbols() :: list(String.t())
  def symbols do
    ["@", "$", "*", "#", "&", "%", "+", "-", "/", "="]
  end

  @type engine_data() :: list(list(number | String.t()))
  @type engine_parts() :: list(PossibleEnginePart)
  @type engine_symbols() :: list(EngineSymbol)

  # construct 2d array out of the input data, separated by new lines
  @spec parse_engine_schematic_to_engine_data(input :: String.t()) :: engine_data
  def parse_engine_schematic_to_engine_data(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn letters -> String.split(letters, "", trim: true) end)
  end

  @spec parse_engine_schematic_and_return_parts_and_symbols(input :: String.t()) :: map()
  def parse_engine_schematic_and_return_parts_and_symbols(input) do
    data =
      input
      |> GearRatios.Core.parse_engine_schematic_to_engine_data()

    engine_parts =
      data
      |> GearRatios.Core.find_engine_parts_from_engine_data()

    symbols =
      data
      |> GearRatios.Core.find_engine_symbols_from_engine_data()

    %{engine_parts: engine_parts, engine_symbols: symbols}
  end

  @spec parse_engine_schematic_and_return_sum(input :: String.t()) :: number
  def parse_engine_schematic_and_return_sum(input) do
    %{engine_parts: engine_parts, engine_symbols: symbols} =
      parse_engine_schematic_and_return_parts_and_symbols(input)

    GearRatios.Core.sum_up_parts(engine_parts, symbols)
  end

  @spec parse_engine_schematic_and_return_sum_gear_ratios(input :: String.t()) :: number
  def parse_engine_schematic_and_return_sum_gear_ratios(input) do
    %{engine_parts: engine_parts, engine_symbols: symbols} =
      parse_engine_schematic_and_return_parts_and_symbols(input)

    GearRatios.Core.sum_up_gear_ratios(engine_parts, symbols)
  end

  # find list of unique part numbers
  @spec find_engine_parts_from_engine_data(engine_data :: engine_data) :: engine_parts
  def find_engine_parts_from_engine_data(engine_data) do
    # iterate through list, for each item if lookahead is a number, keep looking ahead and store
    engine_data
    |> Enum.with_index()
    |> Enum.map(fn {engine_data_row, y} ->
      engine_data_row
      |> Enum.with_index()
      |> Enum.map(fn {engine_data_char, x} ->
        cond do
          # if already counted this digit, keep movin
          x > 0 && is_an_integer(Enum.at(engine_data_row, x - 1)) ->
            nil

          # if digit is number, start to look ahead and collect the numbers
          is_an_integer(engine_data_char) ->
            data_for_saving =
              engine_data_row
              |> Enum.slice(x, Kernel.length(engine_data_row))
              |> Enum.reduce_while("", fn lookahead_char, acc ->
                if is_an_integer(lookahead_char) do
                  {:cont, "#{acc}#{lookahead_char}"}
                else
                  {:halt, acc}
                end
              end)

            %GearRatios.PossibleEnginePart{
              part_number: String.to_integer(data_for_saving),
              x: x,
              y: y
            }

          true ->
            nil
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
  end

  # generate symbols with adjacent numbers
  @spec find_engine_symbols_from_engine_data(engine_data :: engine_data) :: engine_symbols
  def find_engine_symbols_from_engine_data(engine_data) do
    # iterate through list, for each item if in symbols list, store!
    symbols = symbols()

    engine_data
    |> Enum.with_index()
    |> Enum.map(fn {engine_data_row, y} ->
      engine_data_row
      |> Enum.with_index()
      |> Enum.map(fn {engine_data_char, x} ->
        if Enum.member?(symbols, engine_data_char) do
          %GearRatios.EngineSymbol{
            symbol: engine_data_char,
            x: x,
            y: y
          }
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
  end

  @spec is_an_integer(input :: String.t()) :: boolean
  defp is_an_integer(input) do
    case Integer.parse(input, 10) do
      {_, ""} ->
        true

      :error ->
        false
    end
  end

  # for a given part, iterate through every digit and its position and return true if adjacent to a symbol
  @spec part_number_is_adjacent_to_symbol(
          engine_part :: PossibleEnginePart,
          symbols :: engine_symbols
        ) ::
          boolean
  def part_number_is_adjacent_to_symbol(engine_part, symbols) do
    symbols
    |> Enum.map(fn symbol ->
      "#{engine_part.part_number}"
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {_, idx} ->
        # WARNING - can be massively improved with early breaks likely
        if abs(symbol.x - (engine_part.x + idx)) <= 1 && abs(symbol.y - engine_part.y) <= 1 do
          true
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
    |> Kernel.length() > 0
  end

  @spec symbol_gear_ratio(symbol :: EngineSymbol, engine_parts :: engine_parts) :: number
  def symbol_gear_ratio(symbol, engine_parts) do
    # filter parts that are within in the rows adjacent to it
    # WARNING - could be made more efficient with a better lookup by x + y + part character length radius
    possible_parts_in_gear =
      engine_parts
      # engine parts that are within 1 row or same row are the only ones possible, as parts are horizontal
      |> Enum.filter(fn engine_part ->
        abs(engine_part.y - symbol.y) <= 1
      end)
      |> Enum.reduce([], fn engine_part, acc ->
        if part_number_is_adjacent_to_symbol(engine_part, [symbol]) do
          [engine_part.part_number | acc]
        else
          acc
        end
      end)

    if Kernel.length(possible_parts_in_gear) > 1 do
      possible_parts_in_gear
      |> Enum.product()
    else
      0
    end
  end

  @spec sum_up_gear_ratios(engine_parts :: engine_parts, symbols :: engine_symbols) :: number
  def sum_up_gear_ratios(engine_parts, symbols) do
    symbols
    |> Enum.reduce(0, fn symbol, acc ->
      gear_ratio = symbol_gear_ratio(symbol, engine_parts)
      gear_ratio + acc
    end)
  end

  @spec sum_up_parts(engine_parts :: engine_parts, symbols :: engine_symbols) :: number
  def sum_up_parts(engine_parts, symbols) do
    engine_parts
    |> Enum.reduce(0, fn engine_part, acc ->
      if part_number_is_adjacent_to_symbol(engine_part, symbols) do
        engine_part.part_number + acc
      else
        acc
      end
    end)
  end
end
