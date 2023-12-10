require "option_parser"

require "./core"

include Core

# https://adventofcode.com/2023/day/2#part2

file = ""
OptionParser.parse do |parser|
  parser.banner  = "Use this with: crystal ./main.cr -- -h"

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-f FILEPATH", "--filepath=FILEPATH", "Specify a filepath to load raw data" do |file_path|
    file = File.read(file_path)
  end
end

unless file.empty?
  games = parse_games(file)
  puts "Total sum of games by constraints: #{games.sum_possible_games_by_constraints({
    "red" => 12,
    "green" => 13,
    "blue" => 14
  })}"
  puts "Total sum of power of cubes: #{games.sum_of_power_of_cubes}"
end
