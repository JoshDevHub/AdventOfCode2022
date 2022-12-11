# frozen_string_literal: true

# monkeh
class Monkey
  attr_reader :number, :items, :mod_test, :inspect_count
  attr_writer :mod

  def initialize(**data)
    data.each { |k, v| instance_variable_set("@#{k}", v) } # to save me typing lmao
    @inspect_count = 0
    @mod = nil
  end

  def inspect_items
    throw_list = @items.map do |item|
      @inspect_count += 1
      new_item = operate_on_item(item)
      throw_target = (new_item % @mod_test).zero? ? @throw_group[0] : @throw_group[1]
      [throw_target, new_item]
    end
    @items.clear
    throw_list
  end

  def operate_on_item(item)
    op1, operator, op2 = @operation.map { |e| e == "old" ? item : e }
    new_item_val = op1.to_i.send(operator, op2.to_i)
    @mod ? new_item_val % @mod : new_item_val / 3
  end
end

@input = File.read(*ARGV, chomp: true).split("\n\n")

def create_monkey_list
  @input.map do |group|
    number, items, operation, test, true_op, false_op = group.split("\n")
    Monkey.new(
      number: number.scan(/\d+/)[0].to_i,
      items: items.scan(/\d+/).map(&:to_i),
      operation: operation.split[-3..],
      mod_test: test.split[-1].to_i,
      throw_group: [true_op[-1], false_op[-1]].map(&:to_i)
    )
  end
end

def throw_procedure(monkey_list, monkey)
  throw_list = monkey.inspect_items
  throw_list.each { |destination, item| monkey_list[destination].items << item }
end

first_list = create_monkey_list

20.times do
  first_list.each { |monkey| throw_procedure(first_list, monkey) }
end

p first_list.map(&:inspect_count).max(2).reduce(:*) # p1-> 90882

second_list = create_monkey_list
mod = second_list.map(&:mod_test).reduce(:*)
second_list.each { |monkey| monkey.mod = mod }

10_000.times do
  second_list.each { |monkey| throw_procedure(second_list, monkey) }
end

p second_list.map(&:inspect_count).max(2).reduce(:*) # p2-> 30893109657
