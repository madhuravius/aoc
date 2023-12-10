require "spec"

require "../core"

include Core

describe Core do
  describe Tiles do
    tiles = parse_tiles(".....
.S-7.
.|.|.
.L-J.
.....")
    tiles_2 = parse_tiles("-L|F7
7S-7|
L|7||
-L-J|
L|-JF")
    tiles_3 = parse_tiles("..F7.
.FJ|.
SJ.L7
|F--J
LJ...")
    tiles_4 = parse_tiles("7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ")
    it "parser functions as expected (no start)" do
      tiles.tiles.size.should eq(5)
      tiles.tiles[0].size.should eq(5)
      tiles.starting_coords.should eq([1, 1])
    end

    it "pipe connects two tiles should correctly rule out diagonals" do
      pipe_connects_two_tiles(0, 0, "A", 1, 1, "B").should be_false
      pipe_connects_two_tiles(0, 0, "A", -1, -1, "B").should be_false
      pipe_connects_two_tiles(0, 0, "A", -1, 1, "B").should be_false
      pipe_connects_two_tiles(0, 0, "A", 1, -1, "B").should be_false
    end

    it "pipes in adjacent locations should only be marked as true if connectable" do
      # cannot go above F, 7, -
      pipe_connects_two_tiles(0, 0, "-", 0, 1, "|").should be_false
      pipe_connects_two_tiles(0, 0, "L", 0, 1, "|").should be_false
      pipe_connects_two_tiles(0, 0, "J", 0, 1, "|").should be_false

      # below cannot be -, F, 7
      pipe_connects_two_tiles(0, 0, "-", 0, -1, "|").should be_false
      pipe_connects_two_tiles(0, 0, "F", 0, -1, "|").should be_false
      pipe_connects_two_tiles(0, 0, "7", 0, -1, "|").should be_false

      # right cannot be |, L, F
      pipe_connects_two_tiles(0, 0, "|", 1, 0, "|").should be_false
      pipe_connects_two_tiles(0, 0, "L", 1, 0, "|").should be_false
      pipe_connects_two_tiles(0, 0, "F", 1, 0, "|").should be_false

      # left cannot be |, L, F
      pipe_connects_two_tiles(0, 0, "|", -1, 0, "|").should be_false
      pipe_connects_two_tiles(0, 0, "J", -1, 0, "|").should be_false
      pipe_connects_two_tiles(0, 0, "7", -1, 0, "|").should be_false
    end

    it "follows pipe until end with appropriate counter" do
      tiles.follow_pipe_to_end_and_return_midpoint.should eq(4)
      tiles_2.follow_pipe_to_end_and_return_midpoint.should eq(4)
      tiles_3.follow_pipe_to_end_and_return_midpoint.should eq(8)
      tiles_4.follow_pipe_to_end_and_return_midpoint.should eq(8)
    end
  end
end
