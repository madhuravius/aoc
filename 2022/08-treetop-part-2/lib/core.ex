defmodule Treehouse.Core do
  @type tree_data() :: list(list(number))

  # construct 2d array out of the input data, separated by new lines
  @spec parse_tree_cover_data(input :: String.t()) :: tree_data
  def parse_tree_cover_data(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn letters ->
      letters
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(fn letter ->
        letter
        |> String.trim()
        |> Integer.parse(10)
        |> elem(0)
      end)
    end)
  end

  @spec maximum_distance_visible_product(tree_data :: tree_data) :: number
  def maximum_distance_visible_product(tree_data) do
    tree_data
    |> Enum.with_index()
    |> Enum.map(fn {row, y_idx} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {_, x_idx} ->
        distance_visible_product(tree_data, x_idx, y_idx)
      end)
    end)
    |> List.flatten()
    |> Enum.max()
  end

  @spec distance_visible_product(tree_data :: tree_data, x :: number, y :: number) :: number
  def distance_visible_product(tree_data, x, y) do
    value =
      tree_data
      |> Enum.at(y)
      |> Enum.at(x)

    # traverse vertically
    if x == 0 || y == 0 || x == length(tree_data) - 1 || y == length(Enum.at(tree_data, 0)) - 1 do
      1
    else
      # traverse vertically up 
      above =
        Enum.to_list(y..0)
        |> Enum.reduce_while(1, fn y_idx, acc ->
          if !(y_idx == y) do
            if value >
                 Enum.at(tree_data, y_idx)
                 |> Enum.at(x) do
              {:cont, y - y_idx}
            else
              {:halt, acc}
            end
          else
            {:cont, acc}
          end
        end)

      # traverse vertically down 
      below =
        Enum.to_list(y..(length(tree_data) - 1))
        |> Enum.reduce_while(1, fn y_idx, acc ->
          if !(y_idx == y) do
            if value >
                 Enum.at(tree_data, y_idx)
                 |> Enum.at(x) do
              {:cont, y_idx - y}
            else
              {:halt, acc + 1}
            end
          else
            {:cont, acc}
          end
        end)

      # traverse right 
      right =
        Enum.to_list(x..(length(Enum.at(tree_data, 0)) - 1))
        |> Enum.reduce_while(1, fn x_idx, acc ->
          if !(x_idx == x) do
            if value >
                 Enum.at(tree_data, y)
                 |> Enum.at(x_idx) do
              {:cont, x_idx - x}
            else
              {:halt, acc + 1}
            end
          else
            {:cont, acc}
          end
        end)

      # traverse left 
      left =
        Enum.to_list(x..0)
        |> Enum.reduce_while(1, fn x_idx, acc ->
          if !(x_idx == x) do
            if value >
                 Enum.at(tree_data, y)
                 |> Enum.at(x_idx) do
              {:cont, x - x_idx}
            else
              {:halt, acc}
            end
          else
            {:cont, acc}
          end
        end)

      right * left * above * below
    end
  end
end
