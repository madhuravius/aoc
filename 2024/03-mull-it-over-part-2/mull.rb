# frozen_string_literal: true

# ...
class Mul
  attr_reader :input, :processed_input, :pairs, :processed_pairs

  def initialize(input)
    @input = input
    @pairs = extract_pairs
    @processed_input = process_input
    @processed_pairs = extract_processed_pairs
    print "Input: #{@input}"
  end

  def extract_pairs
    @input.scan(/mul\((\d+),(\d+)\)/)
  end

  def extract_processed_pairs
    @processed_input.scan(/mul\((\d+),(\d+)\)/)
  end

  def process_input
    accumulator = ''
    accumulating = true
    (0..@input.size).each do |i|
      if i >= 'do()'.length - 1 && @input[i - 'do()'.length + 1..i] == 'do()'
        accumulating = true
      elsif i >= "don't".length - 1 && @input[i - "don't".length + 1..i] == "don't"
        accumulating = false
      end

      accumulator += @input[i] if accumulating && i < @input.size
    end
    accumulator
  end

  def sum_total_scores
    @pairs.map { |pair| pair[0].to_i * pair[1].to_i }.sum
  end

  def sum_total_scores_of_processed_pairs
    @processed_pairs.map { |pair| pair[0].to_i * pair[1].to_i }.sum
  end
end
