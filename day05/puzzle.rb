# frozen_string_literal: true

ascii_stacks, INSTRUCTIONS = File.read(*ARGV)
                                 .split("\n\n")
                                 .map { |half| half.split("\n") }

matrix_stacks = ascii_stacks.map(&:chars).transpose.map(&:reverse)
stack_collection = matrix_stacks.filter_map do |line|
  input_chars = line.join.scan(/[A-Z]/)
  input_chars unless input_chars.empty?
end

move_by_one = lambda do |stacks, count, from, to|
  count.times { stacks[to] << stacks[from].pop }
end

move_by_multiples = lambda do |stacks, count, from, to|
  stacks[to] += stacks[from].pop(count)
end

def execute_instructions(stacks, &block)
  stacks_copy = Marshal.load(Marshal.dump(stacks))
  INSTRUCTIONS.each do |move|
    count, from, to = move.scan(/\d+/).map(&:to_i)
    block.call(stacks_copy, count, from - 1, to - 1)
  end
  stacks_copy.map(&:last).join
end

p execute_instructions(stack_collection, &move_by_one) # p1-> "WCZTHTMPS"

p execute_instructions(stack_collection, &move_by_multiples) # p2-> "BLSGJSDTS"
