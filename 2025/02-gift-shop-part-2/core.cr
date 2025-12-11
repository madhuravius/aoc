module Core
  class Products
    property product_ids : Array(Array(Int64))
    property n_size_divisors : Hash(Int32, Array(Int32))

    def initialize(@product_ids)
      @n_size_divisors = Hash(Int32, Array(Int32)).new
    end

    def invalid_id_sum
      sum : Int64 = 0
      product_ids.each do |product_id_range|
        (product_id_range[0]..product_id_range[1]).each do |num|
          sum += num if is_invalid_id(num)
        end
      end
      sum
    end

    def is_invalid_id(num : Int64)
      num_as_str = num.to_s.chars

      nums_to_check = n_size_set(num_as_str.size)
      nums_to_check.each do |num_to_check|
        if num_as_str.each_slice(num_to_check).to_a.uniq.size == 1
          puts "invalid id - #{num_as_str.join}"
          return true
        end
      end

      return false
    end

    def n_size_set(size)
      return n_size_divisors[size] if n_size_divisors.has_key?(size)

      arr = [] of Int32
      (1..size).to_a.each do |n|
        arr << n if size % n == 0 && size != n
      end
      n_size_divisors[size] = arr
    end
  end

  def parse_product_ids(input)
    product_ids = input
      .strip
      .split(",")
      .map { |line| line.split("-").map { |entry| entry.to_i64 } }
    Products.new(product_ids: product_ids)
  end
end
