# frozen_string_literal: true

require_relative './mull'
require 'test/unit'

# ...
class TestMul < Test::Unit::TestCase
  setup do
    @sample_data = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  end

  def test_mul_sum
    mul = Mul.new(@sample_data)
    assert_equal(mul.sum_total_scores, 161)
  end

  def test_processed_mul_sum
    mul = Mul.new(@sample_data)
    assert_equal(mul.sum_total_scores_of_processed_pairs, 48)
  end
end
