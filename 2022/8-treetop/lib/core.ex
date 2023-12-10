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

  @spec compute_visible_trees(tree_data :: tree_data) :: number
  def compute_visible_trees(tree_data) do
    tree_data
    |> Enum.with_index()
    |> Enum.map(fn {row, y_idx} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {_, x_idx} ->
        if is_square_visible(tree_data, x_idx, y_idx) do
          1
        else
          0
        end
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  @spec is_square_visible(tree_data :: tree_data, x :: number, y :: number) :: bool
  def is_square_visible(tree_data, x, y) do
    value =
      tree_data
      |> Enum.at(y)
      |> Enum.at(x)

    # traverse vertically
    if x == 0 || y == 0 || x == length(tree_data) - 1 || y == length(Enum.at(tree_data, 0)) - 1 do
      true
    else
      # traverse vertically up 
      above =
        Enum.to_list(0..y)
        |> Enum.map(fn y_idx ->
          if !(y_idx == y) do
            value >
              Enum.at(tree_data, y_idx)
              |> Enum.at(x)
          else
            true
          end
        end)
        |> Enum.all?()

      # traverse vertically down 
      below =
        Enum.to_list(y..(length(tree_data) - 1))
        |> Enum.map(fn y_idx ->
          if !(y_idx == y) do
            value >
              Enum.at(tree_data, y_idx)
              |> Enum.at(x)
          else
            true
          end
        end)
        |> Enum.all?()

      # traverse right 
      right =
        Enum.to_list(x..(length(Enum.at(tree_data, 0)) - 1))
        |> Enum.map(fn x_idx ->
          if !(x_idx == x) do
            value >
              Enum.at(tree_data, y)
              |> Enum.at(x_idx)
          else
            true
          end
        end)
        |> Enum.all?()

      # traverse left 
      left =
        Enum.to_list(0..x)
        |> Enum.map(fn x_idx ->
          if !(x_idx == x) do
            value >
              Enum.at(tree_data, y)
              |> Enum.at(x_idx)
          else
            true
          end
        end)
        |> Enum.all?()
      right || left || above || below
    end
  end
end
