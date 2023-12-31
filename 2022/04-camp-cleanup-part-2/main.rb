# frozen_string_literal: true

# https://adventofcode.com/2022/day/4

require_relative 'camp'

ARGV.empty? && (raise 'Not enough arguments provided. Provide a file, like: ruby main.rb data.txt')

camp_cleanup = CampCleanup.new(File.read(ARGV[0]))
puts "Total cleanup (#{camp_cleanup.pairs.size}) fully inclusive pairs: #{camp_cleanup.num_fully_within_range}"
puts "Total cleanup pairs that do overlap: #{camp_cleanup.num_overlaps}"
