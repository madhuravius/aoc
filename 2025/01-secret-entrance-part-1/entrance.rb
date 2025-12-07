# frozen_string_literal: true

# ...
class Entrance
  attr_reader :input, :password

  def initialize(input)
    @input = input
    @data = process_input
    @password = 0
    print "Input: #{@data}\n"
  end

  def crack
    pos = 50
    @data.each do |row|
      direction = row[:direction]
      units = row[:units]
      direction == 'L' ? pos -= units : pos += units

      @password += 1 if (pos % 100).zero?
    end
  end

  private

  def process_input
    @input.split("\n").map { |r| { direction: r[0], units: r[1..].to_i } }
  end
end
