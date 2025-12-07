# frozen_string_literal: true

require_relative './entrance'
require 'test/unit'

# ...
class TestEntrance < Test::Unit::TestCase
  setup do
    @sample_data = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82"
  end

  def test_entrance_password
    e = Entrance.new(@sample_data)
    e.crack
    assert_equal(e.password, 3)
  end
end
