# frozen_string_literal: true

require_relative './incidence'
require 'test/unit'

# ...
class TestIncidence < Test::Unit::TestCase
  setup do
    @vertical_data = "#.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#."
    @horizontal_data = "#...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  "
    @sample_data = "#{@vertical_data}\n\n#{@horizontal_data}"
  end

  def test_parser
    incidence = PointOfIncidence.new(@sample_data)
    assert_equal(incidence.reflections.size, 2)
  end

  def test_total_sum
    incidence = PointOfIncidence.new(@sample_data)
    assert_equal(incidence.sum_total_scores, 405)
  end

  def test_reflection_setup_simple
    reflection = Reflection.new("--\n##")
    assert_equal(reflection.reflections, [
                   ['-', '-'],
                   ['#', '#']
                 ])
    assert_equal(reflection.transposed_reflections, [
                   ['-', '#'],
                   ['-', '#']
                 ])
    assert_equal(reflection.columns, 1)
  end

  def test_reflection_setup_simple_variant_two
    reflection = Reflection.new("-#\n-#")
    assert_equal(reflection.rows, 1)
  end

  def test_reflection_sample_data_one
    reflection = Reflection.new(@vertical_data)
    assert_equal(reflection.columns, 5)
    assert_equal(reflection.compute_score, 5)
  end

  def test_reflection_sample_data_two
    reflection = Reflection.new(@horizontal_data)
    assert_equal(reflection.rows, 4)
    assert_equal(reflection.compute_score, 400)
  end
end
