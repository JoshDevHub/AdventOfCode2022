# frozen_string_literal: true

def find_packet_marker(input, seq_length)
  input.chars.each_cons(seq_length).with_index do |seq, idx|
    return idx + seq_length if seq.uniq.length == seq_length
  end
end

input = File.read(*ARGV)
p find_packet_marker(input, 4) # p1-> 1912

p find_packet_marker(input, 14) # p2-> 2122
