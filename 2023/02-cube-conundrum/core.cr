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
