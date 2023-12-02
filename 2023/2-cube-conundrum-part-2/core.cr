# As you continue your walk, the Elf poses a second question: in each game you played, what is the fewest number of cubes of each color that could have been in the bag to make the game possible?
#
# Again consider the example games from earlier:
#
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# 
# In game 1, the game could have been played with as few as 4 red, 2 green, and 6 blue cubes. If any color had even one fewer cube, the game would have been impossible.
# Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue cubes.
# Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
# Game 4 required at least 14 red, 3 green, and 15 blue cubes.
# Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
# 
# The power of a set of cubes is equal to the numbers of red, green, and blue cubes multiplied together. The power of the minimum set of cubes in game 1 is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these five powers produces the sum 2286.

module Core
  class Games
    property games : Array(Game)

    def initialize(@games)
    end

    def sum_possible_games_by_constraints(constraints : Hash(String, Int32)) : Int32
      games.map { |game| game.is_possible_with_constraints(constraints: constraints) ? game.game_id : 0 }.sum
    end

    def sum_of_power_of_cubes 
      games.map { |game| game.power_of_cubes }.sum
    end
  end

  class Game
    property game_id : Int32
    property game_instances : Array(GameInstance)

    def initialize(@game_id, @game_instances)
    end

    def is_possible_with_constraints(constraints : Hash(String, Int32)) : Bool
      game_instances.all? { |game_instance| game_instance.is_possible_with_constraints(constraints: constraints) }
    end

    def power_of_cubes
      # WARNING - this could be massively optimized ot keep track on insert, but that does not matter for this game
      maximum_cube_counts = {} of String => Int32
      game_instances.each do |game_instance|
        game_instance.cube_counts.each do |color, count|
          if maximum_cube_counts.has_key? color
            if maximum_cube_counts[color] < count
              maximum_cube_counts[color] = count
            end
          else
            maximum_cube_counts[color] = count
          end
        end
      end
      maximum_cube_counts.values.product
    end
  end

  class GameInstance
    property game_id : Int32
    property game_instance_id : Int32
    property cube_counts : Hash(String, Int32)

    def initialize(@game_id, @game_instance_id, @cube_counts)
    end

    def is_possible_with_constraints(constraints : Hash(String, Int32)) : Bool
      possible = true
      constraints.map do |constraint_key, constraint_value|
        next unless cube_counts.has_key? constraint_key
        if cube_counts[constraint_key] > constraint_value
          possible = false
          break
        end
      end
      possible
    end
  end

  def parse_game_cube_color(input)
    count_and_color_text = input.split(" ")
    count = count_and_color_text[0]
    color_text = count_and_color_text[1..].join(" ")
    {count.to_i, color_text}
  end

  def parse_game_instance(input)
    cube_counts = {} of String => Int32
    input.split(",")
      .map { |game_count_and_cube_color_text| parse_game_cube_color(game_count_and_cube_color_text.strip) }
      .each { |count, color| cube_counts[color] = count }

    cube_counts
  end

  def parse_game(input)
    game_line = input.split(":")
    game_id = game_line[0].split(" ")[1].to_i
    game_instances = game_line[1].split(";")
      .map_with_index { |game_instance_input, idx| GameInstance.new(
        game_id: game_id,
        game_instance_id: idx,
        cube_counts: parse_game_instance(game_instance_input)
      ) }
    Game.new(game_id: game_id, game_instances: game_instances)
  end

  def parse_games(input : String)
    games = input.strip.split("\n").map { |game_input_line| parse_game(game_input_line) }
    Games.new(games: games)
  end
end
