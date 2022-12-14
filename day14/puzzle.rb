# frozen_string_literal: true

require "set"

input = File.readlines(*ARGV, chomp: true)

@obstacles = Set.new
input.each do |line_group|
  coordinates = line_group.split(" -> ")
  coordinates.each_cons(2) do |start, term|
    sx, sy = start.split(",").map(&:to_i)
    tx, ty = term.split(",").map(&:to_i)
    if sx == tx
      y0, y1 = [sy, ty].minmax
      (y0..y1).each { |y| @obstacles << [sx, y] }
    else
      x0, x1 = [sx, tx].minmax
      (x0..x1).each { |x| @obstacles << [x, sy] }
    end
  end
end

FLOOR = @obstacles.to_a.max_by(&:last).last
def out_of_bounds?(y) = y > FLOOR

def drop_sand(x = 500, y = 0)
  potential_points = [[x, y + 1], [x - 1, y + 1], [x + 1, y + 1]]
  drop_coord = potential_points.find do |point|
    !@sand_pile.include?(point) && !@obstacles.include?(point)
  end
  return [x, y] if !drop_coord || out_of_bounds?(y)

  drop_sand(*drop_coord)
end

@sand_pile = Set.new

loop do
  new_sand_coord = drop_sand
  break if out_of_bounds?(new_sand_coord[1])

  @sand_pile << new_sand_coord
end

p @sand_pile.size # p1-> 672

ARBITRARY_LEFT = 300
ARBITRARY_RIGHT = 800
UPDATED_FLOOR = FLOOR + 2
(ARBITRARY_LEFT..ARBITRARY_RIGHT).each { |arb_x| @obstacles << [arb_x, UPDATED_FLOOR] }

@sand_pile.clear
ORIGIN = [500, 0].freeze

loop do
  new_sand_coord = drop_sand
  @sand_pile << new_sand_coord
  break if new_sand_coord == ORIGIN
end

p @sand_pile.size # p2-> 26831
