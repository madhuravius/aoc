# frozen_string_literal: true

# https://adventofcode.com/2022/day/4

require_relative './incidence'

ARGV.empty? && (raise 'Not enough arguments provided. Provide a file, like: ruby main.rb data.txt')

incidence = PointOfIncidence.new(File.read(ARGV[0]))
puts "Total mirrored score: #{incidence.sum_total_scores}"
