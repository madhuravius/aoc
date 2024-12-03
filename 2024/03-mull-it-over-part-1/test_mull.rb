# frozen_string_literal: true

require_relative './mull'
require 'test/unit'

# ...
class TestMul < Test::Unit::TestCase
  setup do
    @sample_data = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'
  end

  def test_mul_sum
    mul = Mul.new(@sample_data)
    assert_equal(mul.sum_total_scores, 161)
  end
end
