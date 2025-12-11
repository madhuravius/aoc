require "option_parser"

require "./core"

include Core

# https://adventofcode.com/2025/day/2

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
  products = parse_product_ids(file)
  puts "Invalid id sum: #{products.invalid_id_sum}"
end
