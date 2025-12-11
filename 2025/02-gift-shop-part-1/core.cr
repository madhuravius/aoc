module Core
  class Products
    property product_ids : Array(Array(Int64))

    def initialize(@product_ids)
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
      return false if num_as_str.size % 2 == 1

      half = (num_as_str.size / 2).to_i
      return num_as_str.first(half) == num_as_str.last(half)
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
