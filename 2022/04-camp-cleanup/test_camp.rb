# frozen_string_literal: true

require_relative 'camp'
require 'test/unit'

# ...
class TestPair < Test::Unit::TestCase
  def test_pair
    pair = Pair.new('2-4,6-8')
    assert_equal(pair.range_1_start, 2)
    assert_equal(pair.range_1_end, 4)
    assert_equal(pair.range_2_start, 6)
    assert_equal(pair.range_2_end, 8)
  end

  def test_fully_within_range_true
    pair = Pair.new('2-8,3-7')
    assert_equal(pair.fully_within_range, true)
  end

  def test_fully_within_range_true_variant
    pair = Pair.new('3-7,2-8')
    assert_equal(pair.fully_within_range, true)
  end

  def test_fully_within_range_false
    pair = Pair.new('2-8,1-7')
    assert_equal(pair.fully_within_range, false)
  end
end

# ...
class TestCampCleanup < Test::Unit::TestCase
  def test_camp_cleanup
    camp_cleanup = CampCleanup.new("2-4,6-8\n"\
                                   "2-3,4-5\n"\
                                   "5-7,7-9\n"\
                                   "2-8,3-7\n"\
                                   "6-6,4-6\n"\
                                   '2-6,4-8')
    assert_equal(camp_cleanup.pairs.size, 6)
    assert_equal(camp_cleanup.num_fully_within_range, 2)
  end
end
