# frozen_string_literal: true

require_relative 'supply'
require 'test/unit'

# ...
class TestStacks < Test::Unit::TestCase
  def test_stacks
    input = File.read('./fixtures/test_input.txt')
    stacks = Stacks.new(input)

    assert_equal(stacks.stacks.size, 3)
    assert_equal(stacks.final_output, 'CMZ')
  end
end
