require "spec"

require "../core"

include Core

describe Core do
  describe Guard do
    grid = parse_grid("....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...")
    it "properly initializes guard" do
      guard = Guard.new(grid)
      guard.x.should eq(4)
      guard.y.should eq(6)
    end
    it "properly computes path" do
      grid.debug
      guard = Guard.new(grid)
      guard.compute_path
      guard.traveled_cells.should eq(41)
    end
  end
end
