# frozen_string_literal: true

# https://adventofcode.com/2025/day/1

require_relative './entrance'

ARGV.empty? && (raise 'Not enough arguments provided. Provide a file, like: ruby main.rb data.txt')

e = Entrance.new(File.read(ARGV[0]))
e.crack
print "Password cracked: #{e.password}"
