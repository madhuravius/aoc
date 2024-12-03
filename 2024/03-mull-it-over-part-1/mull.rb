# frozen_string_literal: true

# ...
class Mul
  attr_reader :input, :pairs

  def initialize(input)
    @input = input
    @pairs = extract_pairs
    print "Input: #{@input}"
  end

  def extract_pairs
    @input.scan(/mul\((\d+),(\d+)\)/)
  end

  def sum_total_scores
    @pairs.map { |pair| pair[0].to_i * pair[1].to_i }.sum
  end
end
