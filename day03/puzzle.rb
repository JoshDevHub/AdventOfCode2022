# frozen_string_literal: true

input = File.readlines(*ARGV, chomp: true).map(&:chars)

error_chars = input.map do |rucksack|
  left, right = rucksack.each_slice(rucksack.length / 2).to_a
  left & right
end

badge_chars = input.each_slice(3).map { |f, *rest| f.intersection(*rest) }

def calculate_priority_for(char_list)
  char_list.flatten.map(&:ord).sum do |ascii|
    ascii - (ascii >= 97 ? 96 : 38)
  end
end

p calculate_priority_for(error_chars) # p1-> 7763

p calculate_priority_for(badge_chars) # p2-> 2569
