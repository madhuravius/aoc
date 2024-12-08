require "option_parser"

require "./core"

include Core

# https://adventofcode.com/2024/day/6

file = ""
OptionParser.parse do |parser|
  parser.banner = "Use this with: crystal ./main.cr -h"

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-f FILEPATH", "--filepath=FILEPATH", "Specify a filepath to load raw data" do |file_path|
    file = File.read(file_path)
  end
end

unless file.empty?
  grid = parse_grid(file)
  grid.debug

  guard = Guard.new(grid)
  guard.compute_path

  puts "Traveled cells: #{guard.traveled_cells}"

  fresh_grid = parse_grid(file)
  puts "Traveled cells with obstacles: #{fresh_grid.compute_all_guards_possible_paths}"
  # 
  # brute_grid = parse_grid(file)
  # puts "Traveled cells with obstacles: #{brute_grid.brute_force_alternative}"
end
