# frozen_string_literal: true

# https://adventofcode.com/2024/day/3

require_relative './mull'

ARGV.empty? && (raise 'Not enough arguments provided. Provide a file, like: ruby main.rb data.txt')

mul = Mul.new(File.read(ARGV[0]))
puts "Sum of multiplications: #{mul.sum_total_scores}"
puts "Sum of processed multiplications: #{mul.sum_total_scores_of_processed_pairs}"
