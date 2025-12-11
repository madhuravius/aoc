# frozen_string_literal: true

# ...
class Entrance
  attr_reader :input, :password

  def initialize(input)
    @input = input
    @data = process_input
    @password = 0
    @pos = 50
    print "Input: #{@data}\n"
  end

  def crack
    @data.each do |row|
      direction = row[:direction]
      units = row[:units]

      print "start #{@pos}, #{direction} #{units} to password #{password}\n"
      increment_counter(direction:, units:)
      print "end #{@pos}, #{direction} #{units} to password #{password}\n\n"
    end
  end

  private

  def increment_counter(direction:, units:)
    loop do
      if units >= 100 
        units -= 100
        @password += 1
        print " - inner loop, 100 units wash #{@password}\n"
        next
      end

      if direction == 'L' 
        original_pos = @pos
        @pos -= units
        if @pos < 0
          @pos = 100 + @pos 
          @password += 1 if original_pos > 0 
        end
        @password += 1 if @pos == 0
        print " - inner loop, #{units} units backward #{@password}\n"
      elsif direction == 'R'
        @pos += units
        if @pos >= 100
          @pos = @pos % 100
          @password += 1
        end
        print " - inner loop, #{units} units forward #{@password}\n"
      end
      break
    end
    print " - end of loop pos: #{@pos}\n"
  end

  def process_input
    @input.split("\n").map { |r| { direction: r[0], units: r[1..].to_i } }
  end
end
