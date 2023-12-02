# You play several games and record the information from each game (your puzzle input). Each game is listed with its ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were revealed from the bag (like 3 red, 5 green, 4 blue).
#
# For example, the record of a few games might look like this:
#
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green cubes.
#
# The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
#
# In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that configuration. However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at once; similarly, game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. If you add up the IDs of the games that would have been possible, you get 8.

module Core
  class Games
    property games : Array(Game)

    def initialize(@games)
    end

    def sum_possible_games_by_constraints(constraints : Hash(String, Int32)) : Int32
      games.map { |game| game.is_possible_with_constraints(constraints: constraints) ? game.game_id : 0 }.sum
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
