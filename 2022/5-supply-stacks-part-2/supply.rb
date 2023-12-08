# frozen_string_literal: true

# ...
class Stack
  attr_accessor :crates, :id

  def initialize(id)
    @id = id
    @crates = []
  end
end

# ...
class Stacks
  attr_accessor :stacks

  def initialize(input)
    stacks_data, moves_data = input.split("\n\n")
    @stacks = []
    stacks_data.split("\n").reverse.each_with_index.map do |row, row_idx|
      row.split('').each_with_index.map do |character, idx|
        next unless ((idx - 1) % 4).zero?

        if row_idx.zero?
          @stacks.push(Stack.new(id: character))
        elsif row_idx.positive? && character != ' '
          @stacks[(idx - 1) / 4].crates.push(character)
        end
      end
    end
    moves_data.split("\n").map do |move_data|
      puts move_data
      num, from, to = move_data.gsub(/move |from |to /, '').split(' ')
      elems = @stacks[from.to_i - 1].crates.pop(num.to_i)
      @stacks[to.to_i - 1].crates.concat(elems)
      print_stacks
    end
  end

  def final_output
    @stacks.map { |s| s.crates.last }.join('')
  end

  def print_stacks
    puts '------'
    @stacks.each do |stack|
      puts stack.crates.map(&:to_s).join(', ')
    end
    puts '------'
  end
end
