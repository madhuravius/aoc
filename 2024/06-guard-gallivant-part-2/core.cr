module Core
  GUARD_MARK           = "^"
  OBSTACLE_MARK        = "#"
  PLACED_OBSTACLE_MARK = "O"

  class Guard
    property already_visited : Hash(String, Bool) = Hash(String, Bool).new
    property debug : Bool
    property directions : Array(String)
    property direction_mapping : Hash(String, Array(Int32)) = {
      "N" => [0, -1],
      "E" => [1, 0],
      "S" => [0, 1],
      "W" => [-1, 0],
    }
    property grid : Grid
    property x : Int32
    property y : Int32
    property traveled_cells : Int32 = 1
    property already_traveled_paths : Array(String) = [] of String
    property in_cycle : Bool = false

    def initialize(@grid, @debug = false, @x = -1, @y = -1, @directions = ["N", "E", "S", "W"])
      if @x == -1 || @y == -1
        initialize_starting_location
      end
    end

    def compute_path(limit = 0)
      counter = 0
      loop do
        if limit > 0
          counter += 1
        end
        break if counter > limit
        break if cycle_detected
        break if !move
      end
    end

    def cycle_detected
      @in_cycle = already_traveled_paths.size - already_traveled_paths.uniq.size > 4
    end

    def move
      if will_go_off_grid
        false
      elsif obstacle_in_front_of_guard
        already_traveled_paths << "#{x},#{y}"
        @directions.rotate!
        true
      else
        new_x, new_y = get_next_coord
        @x = new_x
        @y = new_y
        puts "Advanced to #{@x}, #{@y} (#{directions[0]})" if debug

        if !@already_visited.has_key?("#{x},#{y}")
          @traveled_cells += 1
          @already_visited["#{x},#{y}"] = true
        end

        true
      end
    end

    def obstacle_in_front_of_guard
      new_x, new_y = get_next_coord
      if grid.grid[new_y][new_x] == OBSTACLE_MARK || grid.grid[new_y][new_x] == PLACED_OBSTACLE_MARK
        puts "Obstacle found at #{new_x}, #{new_y}: #{grid.grid[new_y][new_x]} (#{directions[0]})" if debug
        return true
      end
      return false
    end

    def will_go_off_grid
      new_x, new_y = get_next_coord
      if new_x < 0 || new_y < 0 || new_y >= grid.grid.size || new_x >= grid.grid[0].size
        puts "Breaking out at #{new_x}, #{new_y}" if debug
        return true
      end
      return false
    end

    def get_next_coord
      direction = @directions.first
      x_delta, y_delta = @direction_mapping[direction]
      new_x = x + x_delta
      new_y = y + y_delta
      [new_x, new_y]
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
    property already_computed_path : Hash(String, Bool) = Hash(String, Bool).new

    def initialize(@grid)
    end

    def debug
      grid.each do |row|
        puts row.join("")
      end
    end

    def brute_force_alternative
      # places a block in front of every imaginable square and nukes
      out_final = Grid.new(self.grid.map { |row| row.map { |str| str.dup } })
      counter = 0
      loop_iter = 0
      grid.each_with_index do |row, y|
        row.each_with_index do |row, x|
          loop_iter += 1
          next if grid[y][x] == OBSTACLE_MARK

          guard_starter_check = Guard.new(self, false)
          next if grid[y][x] == [guard_starter_check.y, guard_starter_check.x]

          grid_clone = Grid.new(self.grid.map { |row| row.map { |str| str.dup } })
          grid_clone.set_value(x, y, PLACED_OBSTACLE_MARK)
          simulated_guard = Guard.new(grid_clone, false, -1, -1)
          simulated_guard.compute_path(limit = 2 * grid.size * grid[0].size)

          counter += 1 if simulated_guard.in_cycle
          out_final.set_value(x, y, PLACED_OBSTACLE_MARK) if simulated_guard.in_cycle
          puts "Progress #{loop_iter}/#{grid.size*grid[0].size}" if x % 10 == 0
        end
      end
      out_final.debug
      counter
    end

    def compute_all_guards_possible_paths
      # this follow along the guard path and only places blocks in front and detects loop
      already_counted_locations = Hash(String, Bool).new
      starting_location = [-1, -1]
      x = -1
      y = -1
      travels = 0
      total_travel = 0
      counter = 0
      directions = ["N", "E", "S", "W"]
      obstacles_found = 0
      loop do
        if travels == 0
          guard = Guard.new(self, false)
          starting_location = [guard.x, guard.y]
          guard.compute_path()
          total_travel = guard.traveled_cells
        end

        if x == -1 && y == -1
          guard = Guard.new(self, false)
        else
          guard = Guard.new(self, false, x, y, directions.map { |str| str.dup })
        end

        counter += 1
        puts "Progress: #{travels}/#{total_travel}"

        break if guard.will_go_off_grid

        if guard.obstacle_in_front_of_guard
          directions.rotate!
          next
        end

        x, y = guard.get_next_coord
        next if counter == 1 || [x,y] == starting_location

        travels += 1

        if self.grid[y][x] != OBSTACLE_MARK
          grid_clone = Grid.new(self.grid.map { |row| row.map { |str| str.dup } })
          simulated_guard = Guard.new(grid_clone, false, -1, -1)
          grid_clone.set_value(x, y, PLACED_OBSTACLE_MARK)

          simulated_guard.compute_path(limit = 2 * grid.size * grid[0].size)
          if simulated_guard.in_cycle && !already_counted_locations.has_key?("#{x},#{y}")
            already_counted_locations["#{x},#{y}"] = true
            obstacles_found += 1 
          end
          puts grid_clone.debug if simulated_guard.in_cycle
        end
      end
      obstacles_found
    end

    def set_value(x, y, value)
      self.grid[y][x] = value
    end

    def obstacle_placeable_in_front_of_path
      guard = Guard.new(self)
      guard.compute_path(limit = 1)
      !guard.obstacle_in_front_of_guard
    end

    def placeable_obstacles
      already_computed_path.size
    end
  end

  def parse_grid(input)
    grid_data = input.chomp.split("\n")
      .map { |row| row.split("") }

    Grid.new(grid_data)
  end
end
