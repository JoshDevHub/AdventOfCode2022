# frozen_string_literal: true

require "set"

input = File.readlines(*ARGV, chomp: true)
            .map { |line| line.scan(/\d+/).map(&:to_i) }

Cube = Struct.new(:x, :y, :z) do
  def adjacent_with?(other)
    ((other.x + 1 == x || other.x - 1 == x) && (other.y == y && other.z == z)) ||
      ((other.y + 1 == y || other.y - 1 == y) && (other.x == x && other.z == z)) ||
      ((other.z + 1 == z || other.z - 1 == z) && (other.x == x && other.y == y))
  end

  def create_adjacents
    [
      Cube.new(x, y, z + 1), Cube.new(x, y, z - 1),
      Cube.new(x, y + 1, z), Cube.new(x, y - 1, z),
      Cube.new(x + 1, y, z), Cube.new(x - 1, y, z)
    ]
  end
end

side_count = 0
@cube_set = Set.new
input.each do |x, y, z|
  new_cube = Cube.new(x, y, z)
  adj_cube_count = new_cube.create_adjacents.count { |a| @cube_set.include?(a) }
  side_count += 6 - (2 * adj_cube_count)

  @cube_set << new_cube
end

p side_count

max_x, max_y, max_z = input.transpose.map(&:max)
all_cubes = []
(0..max_x).each do |x|
  (0..max_y).each do |y|
    (0..max_z).each do |z|
      all_cubes << Cube.new(x, y, z)
    end
  end
end


trapped = Set.new
def trapped?(cube)
  q = Queue.new
  q << cube
  visited = Set.new

  until q.empty?
    curr = q.shift
    return false if [curr.x, curr.y, curr.z].min < -1 || [curr.x, curr.y, curr.z].max > 22

    neighbors = curr.create_adjacents
    neighbors.each do |n|
      if !visited.include?(n) && !@cube_set.include?(n)
        visited << n
        q << n
      end
    end
  end
  true
end

all_cubes.each do |cube|
  next if @cube_set.include?(cube)

  trapped << cube if trapped?(cube)
end

area = 0
@cube_set.to_a.each do |cube|
  neighbors = cube.create_adjacents
  neighbors.each do |n|
    area += 1 if !trapped.include?(n) && !@cube_set.include?(n)
  end
end
p area

