# frozen_string_literal: true

require "set"

@input = File.readlines(*ARGV, chomp: true).map(&:split)

Point = Struct.new(:x, :y) do
  def move_in(dir)
    case dir
    when "L" then self.x -= 1
    when "R" then self.x += 1
    when "D" then self.y -= 1
    when "U" then self.y += 1
    end
  end

  def keep_adjacency_with(other)
    dx = other.x - x
    dy = other.y - y
    return if dx.abs < 2 && dy.abs < 2

    self.x += dx.zero? ? 0 : dx / dx.abs
    self.y += dy.zero? ? 0 : dy / dy.abs
  end
end

def count_uniq_tail_positions(knot)
  visit_set = Set.new
  @input.each do |dir, count|
    count.to_i.times do
      head = knot[0]
      head.move_in(dir)
      knot.each_cons(2) { |prev, curr| curr.keep_adjacency_with(prev) }
      visit_set << knot[-1].clone
    end
  end
  visit_set.size
end

short_knot = Array.new(2) { Point.new(0, 0) }
p count_uniq_tail_positions(short_knot) # p1-> 5779

long_knot = Array.new(10) { Point.new(0, 0) }
p count_uniq_tail_positions(long_knot) # p2-> 2331
