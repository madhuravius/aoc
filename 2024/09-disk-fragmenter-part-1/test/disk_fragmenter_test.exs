defmodule DiskFragmenterTest do
  use ExUnit.Case

  test "checksum hard" do
    result = disk_map() |> DiskFragmenter.Core.checksum()
    assert result == 1928
  end

  test "checksum easy" do
    result = "12345" |> DiskFragmenter.Core.checksum()
    # 022111222......
    # 0 + 2*1 + 2*2 + 3*1 + 4*1  + 5*1 + 6*2 + 7*2 + 8*2
    # 0 + 2 + 4 + 3 + 4 + 5 + 12 + 14 + 16
    assert result == 60
  end

  test "checksum easy two" do
    result = "11111" |> DiskFragmenter.Core.checksum()
    assert result == 4
  end

  test "checksum easy three" do
    result = "121" |> DiskFragmenter.Core.checksum()
    assert result == 1
  end

  test "checksum easy four" do
    result = "11221" |> DiskFragmenter.Core.checksum()
    assert result == 7
  end

  test "get_total_dots" do
    result =
      "0..111....22222"
      |> String.split("", trim: true)
      |> translate_to_nils()
      |> DiskFragmenter.Core.get_total_dots()

    assert result == 6
  end

  test "strip_dots" do
    result =
      "0..111....22222"
      |> String.split("", trim: true)
      |> translate_to_nils()
      |> DiskFragmenter.Core.strip_dots()

    assert result == ["0", "1", "1", "1", "2", "2", "2", "2", "2"]
  end

  test "decompact easy" do
    {result, _} = "12345" |> String.split("", trim: true) |> DiskFragmenter.Core.decompact()
    assert result == [0, nil, nil, 1, 1, 1, nil, nil, nil, nil, 2, 2, 2, 2, 2]
  end

  test "decompact hard" do
    {result, _} = disk_map() |> String.split("", trim: true) |> DiskFragmenter.Core.decompact()

    assert result == [
             0,
             0,
             nil,
             nil,
             nil,
             1,
             1,
             1,
             nil,
             nil,
             nil,
             2,
             nil,
             nil,
             nil,
             3,
             3,
             3,
             nil,
             4,
             4,
             nil,
             5,
             5,
             5,
             5,
             nil,
             6,
             6,
             6,
             6,
             nil,
             7,
             7,
             7,
             nil,
             8,
             8,
             8,
             8,
             9,
             9
           ]
  end

  test "defrag easy" do
    {data, _} = "12345" |> String.split("", trim: true) |> DiskFragmenter.Core.decompact()
    result = data |> DiskFragmenter.Core.defrag()
    assert result == [0, 2, 2, 1, 1, 1, 2, 2, 2]
  end

  test "defrag hard" do
    {data, _} = disk_map() |> String.split("", trim: true) |> DiskFragmenter.Core.decompact()
    result = data |> DiskFragmenter.Core.defrag()

    assert result == [
             0,
             0,
             9,
             9,
             8,
             1,
             1,
             1,
             8,
             8,
             8,
             2,
             7,
             7,
             7,
             3,
             3,
             3,
             6,
             4,
             4,
             6,
             5,
             5,
             5,
             5,
             6,
             6
           ]
  end

  defp disk_map do
    "2333133121414131402"
  end

  @spec translate_to_nils(input :: list(number | String.t())) :: list(number | nil)
  def translate_to_nils(input) do
    input
    |> Enum.map(fn digit ->
      if digit == "." do
        nil
      else
        digit
      end
    end)
  end
end
