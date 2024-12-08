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
    it "properly computes path with limit, ensure only +1" do
      grid.debug
      guard = Guard.new(grid)
      guard.compute_path(limit = 1)
      guard.traveled_cells.should eq(2)
    end
    it "propertly breaks cycled grid" do
      cycled_grid = parse_grid(".#...
....#
.^...
#....
...#.")
      cycled_grid.debug
      guard = Guard.new(cycled_grid)
      guard.compute_path(limit = 100)
      guard.traveled_cells.should eq(8)
      guard.in_cycle.should eq(true)
    end
  end
  describe Grid do
    it "properly computes all placeable obstacles" do
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
      grid.debug
      grid.obstacle_placeable_in_front_of_path.should eq(true)
      grid.placeable_obstacles.should eq(0)
    end
    it "properly computes all possible future paths as grid continues" do
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
      grid.compute_all_guards_possible_paths.should eq(6)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid("....
#..#
.^#.")
      grid.compute_all_guards_possible_paths.should eq(1)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid("....
#..#
.^#.")
      grid.compute_all_guards_possible_paths.should eq(1)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".#....
.....#
#..#..
..#...
.^...#
....#.")
      grid.compute_all_guards_possible_paths.should eq(3)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".#..
#..#
....
^...
#...
.#..")
      grid.compute_all_guards_possible_paths.should eq(1)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".#....
.....#
...^..
#.....
....#.")
      grid.compute_all_guards_possible_paths.should eq(1)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".#..
#..#
#...
#...
#...
#...
.^..
..#.")
      grid.compute_all_guards_possible_paths.should eq(6)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".##........
#.........#
#..........
#.....#....
#....#.....
#...#......
..^........
.........#.")
      grid.compute_all_guards_possible_paths.should eq(7)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid("...........
.#.........
.........#.
..#........
.......#...
....#......
...#...#...
......#....
...........
........#..
.^.........")
      grid.compute_all_guards_possible_paths.should eq(4)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".##..
....#
.....
.^.#.
.....")
      grid.compute_all_guards_possible_paths.should eq(1)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".#....
.....#
..#...
.....#
....#.
.^....
......")
      grid.compute_all_guards_possible_paths.should eq(1)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid("##..
...#
....
^.#.")
      grid.compute_all_guards_possible_paths.should eq(0)
    end
    it "properly computes all possible future paths as grid continues" do
      grid = parse_grid(".#...
....#
.....
.^.#.
#....
..#..")
      grid.compute_all_guards_possible_paths.should eq(3)
    end
  end
end
