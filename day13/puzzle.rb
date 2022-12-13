# frozen_string_literal: true

def compare_values(a, b)
  case [a, b]
  in [Integer, Integer] then a <=> b
  in [Array, Array]
    a.zip(b).each do |a_val, b_val|
      break if a_val.nil? || b_val.nil?

      comp = compare_values(a_val, b_val)
      return comp unless comp.zero?
    end
    a.length <=> b.length
  else
    a.is_a?(Integer) ? compare_values([a], b) : compare_values(a, [b])
  end
end

input = File.read(*ARGV).split.map { |packet| eval(packet) }

correct_indices = input.each_slice(2).filter_map.with_index do |pair, idx|
  comp = compare_values(*pair)
  idx + 1 if comp == -1
end
p correct_indices.sum # p1-> 5625

dividers = [[[2]], [[6]]]

all_packets = input + dividers
all_packets.sort! { |a, b| compare_values(a, b) }
decoder_key = dividers.map { |div| all_packets.index(div) + 1 }.reduce(:*)
p decoder_key # p2-> 23111
