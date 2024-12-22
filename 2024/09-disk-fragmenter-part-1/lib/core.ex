defmodule DiskFragmenter.Core do
  @spec checksum(input :: String.t()) :: number
  def checksum(input) do
    {data, _} =
      input
      |> String.trim()
      |> String.split("", trim: true)
      |> DiskFragmenter.Core.decompact()

    data
    |> DiskFragmenter.Core.defrag()
    |> Enum.with_index()
    |> Enum.map(fn {digit, idx} ->
      if digit == nil do
        0
      else
        digit * idx
      end
    end)
    |> Enum.sum()
  end

  @spec decompact(input :: list(number | nil)) :: {list(number | nil), number}
  def decompact(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce({[], 0}, fn {char, idx}, {acc, inc} ->
      {count, ""} = Integer.parse(char, 10)

      if Integer.mod(idx, 2) == 0 do
        {acc ++ List.duplicate(inc, count), inc + 1}
      else
        {acc ++ List.duplicate(nil, count), inc}
      end
    end)
  end

  @spec defrag(input :: list(number | nil)) :: list(number)
  def defrag(input) do
    total_dots = input |> DiskFragmenter.Core.get_total_dots()

    reversed =
      input
      |> Enum.reverse()
      |> DiskFragmenter.Core.strip_dots()

    {prefix, _} =
      input
      |> Enum.with_index()
      |> Enum.reduce({[], 0}, fn {char, idx}, {acc, inc} ->
        characters_left = length(acc) < length(input) - total_dots

        cond do
          characters_left && char == nil ->
            {[Enum.at(reversed, inc) | acc], inc + 1}

          characters_left ->
            {[Enum.at(input, idx) | acc], inc}

          true ->
            {acc, inc}
        end
      end)

    prefix
    |> Enum.reverse()
  end

  @spec strip_dots(input :: list(number | nil)) :: list(number | nil)
  def strip_dots(input) do
    input
    |> Enum.filter(&(&1 != nil))
  end

  @spec get_total_dots(input :: list(number | nil)) :: number
  def get_total_dots(input) do
    input
    |> Enum.filter(&(&1 == nil))
    |> Enum.count()
  end
end
