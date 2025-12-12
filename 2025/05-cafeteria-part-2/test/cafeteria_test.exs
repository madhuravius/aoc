defmodule CafeteriaTest do
  use ExUnit.Case

  test "verify parser functions" do
    ranges = Cafeteria.Core.parse_list("1-2
      2-3

      1
      2
      3
      4
      11")
    assert length(ranges) == 2
  end

  test "verify fresh sample data function" do
    ranges = Cafeteria.Core.parse_list("3-5
      10-14
      16-20
      12-18

      1
      5
      8
      11
      17
      32")
    fresh = Cafeteria.Core.compute_fresh(ranges)
    assert fresh == 14
  end
end
