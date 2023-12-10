require "spec"

require "../core"

include Core

describe Core do
  describe Games do
    games = parse_games("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green")
    it "sum_possible_games_by_constraints should properly return value" do
      games.sum_possible_games_by_constraints({"red" => 12, "green" => 13, "blue" => 14}).should eq(8)
    end
    it "sum_of_power_of_cubes pass" do
      games.sum_of_power_of_cubes.should eq(2286)
    end
  end
  describe Game do
    game = parse_game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
    it "is_possible_with_constraints should fail when over constraint" do
      game.is_possible_with_constraints({"blue" => 2}).should be_false
    end
    it "is_possible_with_constraints should pass" do
      game.is_possible_with_constraints({"blue" => 6, "green" => 2, "red" => 4}).should be_true
    end
    it "power_of_cubes pass" do
      game.power_of_cubes.should eq(48)
    end
  end
  describe GameInstance do
    game_instance = GameInstance.new(game_id: 0, game_instance_id: 0, cube_counts: parse_game_instance("2 blue, 2 light blue, 4 green, 3 red"))
    it "is_possible_with_constraints should fail when over constraint" do
      game_instance.is_possible_with_constraints({"blue" => 1}).should be_false
    end

    it "is_possible_with_constraints should pass" do
      game_instance.is_possible_with_constraints({"blue" => 10, "light blue" => 3, "red" => 5, "green" => 7}).should be_true
    end
  end
  describe "parsers" do
    it "should parse color and count" do
      count, color = parse_game_cube_color("2 blue")
      count.should eq(2)
      color.should eq("blue")
    end
    it "should parse color and count, multiword" do
      count, color = parse_game_cube_color("2 light blue")
      count.should eq(2)
      color.should eq("light blue")
    end
    it "should parse game instance" do
      parse_game_instance("2 blue, 2 light blue, 4 green, 3 red")
        .should eq({
          "blue"       => 2,
          "light blue" => 2,
          "green"      => 4,
          "red"        => 3,
        })
    end
    it "should parse game" do
      game = parse_game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
      game.game_instances.each do |game_instance|
        game_instance.game_id.should eq(1)
        case game_instance.game_instance_id
        when 0
          game_instance.cube_counts.should eq({
            "blue" => 3,
            "red"  => 4,
          })
        when 1
          game_instance.cube_counts.should eq({
            "blue"  => 6,
            "green" => 2,
            "red"   => 1,
          })
        when 2
          game_instance.cube_counts.should eq({
            "green" => 2,
          })
        end
      end
    end
    it "should parse games" do
      games = parse_games("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green")
      games.games.size.should eq(5)
    end
  end
end
