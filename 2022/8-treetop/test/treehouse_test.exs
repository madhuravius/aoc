defmodule TreehouseTest do
  use ExUnit.Case

  test "verify parser functions" do
    result = Treehouse.Core.parse_tree_cover_data("11111
      11211
      11111")
    assert length(result) == 3
  end

  test "is square visible" do
    result = Treehouse.Core.parse_tree_cover_data("11111
      11111
      11211
      11111
      11111")
    assert Treehouse.Core.is_square_visible(result, 2, 2) == true
    assert Treehouse.Core.is_square_visible(result, 1, 1) == false
    assert Treehouse.Core.is_square_visible(result, 0, 0) == true
    assert Treehouse.Core.is_square_visible(result, 3, 0) == true
    assert Treehouse.Core.is_square_visible(result, 0, 3) == true
  end

  test "compute visible trees" do
    result = Treehouse.Core.parse_tree_cover_data("11111
      11111
      11211
      11111
      11111")
    # 5 + 5 + 3 + 3 + 1
    assert Treehouse.Core.compute_visible_trees(result) == 17
  end

  test "compute visible trees (variant 2)" do
    result = Treehouse.Core.parse_tree_cover_data("30373
      25512
      65332
      33549
      35390")
    # 5 + 5 + 3 + 3 + 1
    assert Treehouse.Core.compute_visible_trees(result) == 21
  end
end
