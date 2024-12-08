module Core
  GUARD_MARK    = "^"
  OBSTACLE_MARK = "#"

  class Guard
    property already_visited : Hash(String, Bool) = Hash(String, Bool).new
    property directions : Array(String) = ["N", "E", "S", "W"]
    property direction_mapping : Hash(String, Array(Int32)) = {
      "N" => [0, -1],
      "E" => [1, 0],
      "S" => [0, 1],
      "W" => [-1, 0],
    }
    property grid : Grid
    property x : Int32 = -1
    property y : Int32 = -1
    property traveled_cells : Int32 = 1

    def initialize(@grid)
      initialize_starting_location
    end

    def compute_path
      loop do
        break if !move
        move
      end
    end

    def move
      direction = @directions.first
      x_delta, y_delta = @direction_mapping[direction]
      new_x = x + x_delta
      new_y = y + y_delta
      if new_x < 0 || new_y < 0 || new_x >= grid.grid.size || new_y >= grid.grid[0].size
        false
      elsif grid.grid[new_y][new_x] == OBSTACLE_MARK
        puts "Obstacle found at #{new_x}, #{new_y}"
        @directions.rotate!
        true
      else
        @x = new_x
        @y = new_y
        puts "Advanced to #{@x}, #{@y}"

        if !@already_visited.has_key?("#{x},#{y}")
          @traveled_cells += 1
          @already_visited["#{x},#{y}"] = true
        end

        true
      end
    end

    private def initialize_starting_location
      guard_found = false
      grid.grid.each_with_index do |row, y|
        break if guard_found
        row.each_with_index do |cell, x|
          break if guard_found
          if cell == GUARD_MARK
            @x = x
            @y = y
            @already_visited["#{x},#{y}"] = true
            guard_found = true
          end
        end
      end
    end
  end

  class Grid
    property grid : Array(Array(String))

    def initialize(@grid)
    end

    def debug
      grid.each do |row|
        puts row.join("")
      end
    end
  end

  def parse_grid(input)
    grid_data = input.split("\n")
      .map { |row| row.split("") }

    Grid.new(grid_data)
  end
end
