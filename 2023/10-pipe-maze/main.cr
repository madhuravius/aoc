require "option_parser"

require "./core"

include Core

# https://adventofcode.com/2023/day/10

file = ""
OptionParser.parse do |parser|
  parser.banner = "Use this with: crystal ./main.cr -- -h"

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-f FILEPATH", "--filepath=FILEPATH", "Specify a filepath to load raw data" do |file_path|
    file = File.read(file_path)
  end
end

unless file.empty?
  tiles = parse_tiles(file)
  puts "Midpoint of followed pipe in tile count is: #{tiles.follow_pipe_to_end_and_return_midpoint}"

end
