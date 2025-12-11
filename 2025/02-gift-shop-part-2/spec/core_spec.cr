require "spec"

require "../core"

include Core

describe Core do
  describe Products do
    p = parse_product_ids("11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")
    it "parser functions as expected (no start)" do
      p.product_ids.size.should eq(11)
      p.product_ids[0].size.should eq(2)
    end

    it "should generate invalid_id_sum" do
      p.invalid_id_sum.should eq(4174379265)
    end
  end
end
