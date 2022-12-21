# frozen_string_literal: true

input = File.readlines(*ARGV, chomp: true)

class Monkey
  attr_reader :name, :operation
  attr_accessor :first_operand, :second_operand, :number

  def initialize(name, number: nil, expression: nil)
    @name = name
    @number = number
    @first_operand, @operation, @second_operand = expression
  end

  def resolved?
    @number.is_a? Integer
  end
end

@monkey_map = {}
input.each do |line|
  monkey_name = line[0..3]
  number = line.scan(/\d+/)[0]
  if number
    @monkey_map[monkey_name] = Monkey.new(monkey_name, number: number.to_i)
    next
  end

  expression = line[6..].split
  @monkey_map[monkey_name] = Monkey.new(monkey_name, expression:)
end

def dfs(monkey)
  return monkey.number if monkey.resolved?

  first_op = @monkey_map[monkey.first_operand]
  second_op = @monkey_map[monkey.second_operand]

  num1 = dfs(first_op)
  num2 = dfs(second_op)

  num1.send(monkey.operation, num2)
end

root = @monkey_map["root"]
p dfs(root) # p1-> PART 1

def bsearch(max_guess)
  root = @monkey_map["root"]
  stable_operand = dfs(@monkey_map[root.second_operand])

  left = 0
  right = max_guess

  until left >= right
    mid = (left + right) / 2
    @monkey_map["humn"].number = mid

    changing_operand = dfs(@monkey_map[root.first_operand])
    return mid if changing_operand == stable_operand

    if changing_operand > stable_operand
      left = mid + 1
    else
      right = mid - 1
    end
  end
end

p bsearch(5_100_000_000_000)
