# frozen_string_literal: true

require "set"

input = File.readlines(*ARGV, chomp: true)

range_input = input.map do |line|
  line.scan(/\d+/).map(&:to_i) => [left_min, left_max, right_min, right_max]
  [Set.new(left_min..left_max), Set.new(right_min..right_max)]
end

subset_count = range_input.count do |left, right|
  left.subset?(right) || right.subset?(left)
end

overlap_count = range_input.count { |left, right| left.intersect?(right) }

p subset_count # p1-> 509

p overlap_count # p2-> 870
