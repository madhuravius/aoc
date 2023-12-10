# frozen_string_literal: true

# https://adventofcode.com/2022/day/5

require_relative 'supply'

ARGV.empty? && (raise 'Not enough arguments provided. Provide a file, like: ruby main.rb data.txt')

supply_stacks = Stacks.new(File.read(ARGV[0]))
puts "Final output of top of stacks: #{supply_stacks.final_output}"
