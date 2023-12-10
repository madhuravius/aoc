module Core
  class Tiles
    property tiles : Array(Array(String))
    property starting_coords : Array(Int32)

    def initialize(@tiles)
      @starting_coords = [-1, -1]
      set_starting_coordinates
    end

    def set_starting_coordinates
      x, y = -1, -1
      @tiles.map_with_index do |line, y_idx|
        found = false
        line.map_with_index do |tile, x_idx|
          if tile == "S"
            found = true
            @starting_coords = [y_idx, x_idx]
            break
          end
        end
        break if found
      end
    end

    def follow_pipe_to_end_and_return_midpoint
      # pick either side to begin going, whichever comes first
      current_y, current_x = starting_coords
      already_visited_nodes = ["#{current_x}.#{current_y}"]
      counter = 0

      loop do
        current_tile = @tiles[current_y][current_x]

        if counter > 1000000
          raise "Unable to reach end of pipe"
        end
        # look left
        if current_x > 0 &&
           !already_visited_nodes.includes?("#{current_x - 1}.#{current_y}") &&
           pipe_connects_two_tiles(
             current_x,
             current_y,
             @tiles[current_y][current_x],
             current_x - 1,
             current_y,
             @tiles[current_y][current_x - 1])
          current_x = current_x - 1
          # look right
        elsif current_x < @tiles.size - 1 &&
              !already_visited_nodes.includes?("#{current_x + 1}.#{current_y}") &&
              pipe_connects_two_tiles(
                current_x,
                current_y,
                @tiles[current_y][current_x],
                current_x + 1,
                current_y,
                @tiles[current_y][current_x + 1])
          current_x = current_x + 1
          # look above
        elsif current_y > 0 &&
              !already_visited_nodes.includes?("#{current_x}.#{current_y - 1}") &&
              pipe_connects_two_tiles(
                current_x,
                current_y,
                @tiles[current_y][current_x],
                current_x,
                current_y - 1,
                @tiles[current_y - 1][current_x])
          current_y = current_y - 1
          # look below
        elsif current_y < @tiles[0].size - 1 &&
              !already_visited_nodes.includes?("#{current_x}.#{current_y + 1}") &&
              pipe_connects_two_tiles(
                current_x,
                current_y,
                @tiles[current_y][current_x],
                current_x,
                current_y + 1,
                @tiles[current_y + 1][current_x])
          current_y = current_y + 1
        else
          # only arrive here should all other nodes be visited
          if counter % 2 == 1
            return (counter / 2).to_i + 1
          else 
            return counter / 2
          end
        end
        already_visited_nodes.push("#{current_x}.#{current_y}")

        counter += 1
      end
    end
  end

  def pipe_connects_two_tiles(tile_1_x, tile_1_y, tile_1, tile_2_x, tile_2_y, tile_2)
    # tile_1 is origin, tile_2 is destination
    # if not immediately above, below, right, left, this is not possible as a connector, rule out diagonals
    return false unless tile_1_x == tile_2_x || tile_1_y == tile_2_y

    # for each of the below, also determine the connection and return that
    # S is available for all possible connections

    # if target is above, only applicable to S, L, |, J or those going up: |, F, 7
    if tile_1_x == tile_2_x && tile_1_y - 1 == tile_2_y
      return false unless ["S", "L", "|", "J"].includes? tile_1
      return true if ["S", "|", "F", "7"].includes? tile_2
      # if to the right, must be - S or (going right), 7 (going down), J (going up)
    elsif tile_1_x + 1 == tile_2_x && tile_1_y == tile_2_y
      return false unless ["S", "F", "-", "L"].includes? tile_1
      return true if ["S", "-", "J", "7"].includes? tile_2
      # if to the left, must be - S or (going left), F (going down), L (going up)
    elsif tile_1_x - 1 == tile_2_x && tile_1_y == tile_2_y
      return false unless ["S", "7", "-", "J"].includes? tile_1
      return true if ["S", "-", "L", "F"].includes? tile_2
      # if below, only applicable to S or those going down: |, J, L
    elsif tile_1_x == tile_2_x && tile_1_y + 1 == tile_2_y
      return false unless ["S", "F", "|", "7"].includes? tile_1
      return true if ["S", "|", "L", "J"].includes? tile_2
    end

    return false
  end

  def parse_tiles(input)
    tiles = input
      .strip
      .split("\n")
      .map { |line| line.split("") }
    Tiles.new(tiles: tiles)
  end
end
