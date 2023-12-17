# frozen_string_literal: true

# ...
class Reflection
  attr_reader :data, :lines, :reflections, :transposed_reflections, :reflection_orientation, :rows, :columns

  def initialize(input)
    @data = input
    @lines = input.strip.split("\n")
    @reflections = @lines.map { |line| line.strip.split('') }
    @transposed_reflections = @reflections.map(&:reverse).transpose.reverse
    @rows = 0
    @columns = 0
    determine_orientation
  end

  def determine_orientation
    # horizontal
    @rows = iterate_and_check_equalities(@reflections)
    return if !@rows.nil? && @rows.positive?

    # vertical
    @columns = iterate_and_check_equalities(@transposed_reflections)
  end

  def compute_score
    (@rows * 100) + @columns
  end

  def iterate_and_check_equalities(array)
    return 1 if array.size == 2 && array[0] == array[1]

    count = 0
    array.each_with_index do |_, idx|
      next if !idx.positive? || idx == array.size - 1

      results = compare_possible_mirrors(array, idx)
      next if !(results[:found_match] && results[:found_end]) && count <= results[:count] + 1

      count = results[:count]
    end
    count
  end

  def compare_possible_mirrors(array, idx)
    upper_bound_idx = idx
    lower_bound_idx = idx - 1
    found_match = true
    found_end = false
    while found_match && !found_end
      # continuously look up and down
      found_match = false if array[upper_bound_idx] != array[lower_bound_idx]
      found_end = true if upper_bound_idx == array.size - 1 || lower_bound_idx.zero?

      upper_bound_idx += 1
      lower_bound_idx -= 1
    end

    {
      found_match:,
      found_end:,
      count: idx
    }
  end
end

# ...
class PointOfIncidence
  attr_reader :reflections

  def initialize(input)
    @reflections = convert_input_to_reflections(input)
  end

  def convert_input_to_reflections(input)
    input.strip.split("\n\n").map { |reflection_data| Reflection.new(reflection_data) }
  end

  def sum_total_scores
    @reflections.map(&:compute_score).sum
  end
end
