# frozen_string_literal: true

# https://adventofcode.com/2022/day/4

# ...
class Pair
  attr_reader :range_1_start, :range_2_start, :range_1_end, :range_2_end

  def initialize(input)
    one, two = input.strip.split(',')
    @range_1_start, @range_1_end = one.split('-').map(&:to_i)
    @range_2_start, @range_2_end = two.split('-').map(&:to_i)
  end

  def fully_within_range
    @range_1_start <= @range_2_start && @range_1_end >= @range_2_end ||
      @range_2_start <= @range_1_start && @range_2_end >= @range_1_end
  end
end

# ...
class CampCleanup
  attr_reader :pairs

  def initialize(input)
    @pairs = convert_input_to_pairs(input)
  end

  def convert_input_to_pairs(input)
    @pairs = input.strip.split("\n").map { |pair| Pair.new(pair) }
  end

  def num_fully_within_range
    @pairs.map(&:fully_within_range).select { |p| p }.size
  end
end
