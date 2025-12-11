# frozen_string_literal: true

require_relative './entrance'
require 'test/unit'

# ...
class TestEntrance < Test::Unit::TestCase
  def test_entrance_password
    e = Entrance.new("L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82")
    e.crack
    assert_equal(e.password, 6)
  end
  def test_entrance_password_loop
    e = Entrance.new("R1000\nL68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82")
    e.crack
    assert_equal(e.password, 16)
  end
end
