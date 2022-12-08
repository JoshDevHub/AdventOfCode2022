# frozen_string_literal: true

@input = File.readlines(*ARGV, chomp: true).map(&:chars)

DIRECTIONS = { right: [0, -1], left: [0, 1], up: [-1, 0], down: [1, 0] }.freeze

def outside_grid?(row, col)
  row.negative? || row >= @input.length ||
    col.negative? || col >= @input[0].length
end

def visible?(row, col, tree_height, dir)
  return true if outside_grid?(row, col)
  return false if @input[row][col] >= tree_height

  rd, rc = DIRECTIONS[dir]
  visible?(row + rd, col + rc, tree_height, dir)
end

visible_count = @input.each_with_index.sum do |row, row_i|
  row.each_with_index.count do |tree, col_i|
    DIRECTIONS.any? { |dir, (dr, dc)| visible?(row_i + dr, col_i + dc, tree, dir) }
  end
end

p visible_count # p1-> 1814

def calculate_view_distance(row, col, tree, dir, count = 0)
  return count if outside_grid?(row, col)
  return count + 1 if @input[row][col] >= tree

  dr, dc = DIRECTIONS[dir]
  calculate_view_distance(row + dr, col + dc, tree, dir, count + 1)
end

view_scores = @input.map.with_index do |row, row_i|
  row.map.with_index do |tree, col_i|
    DIRECTIONS.reduce(1) do |score, (dir, (dr, dc))|
      score * calculate_view_distance(row_i + dr, col_i + dc, tree, dir)
    end
  end
end

max_view_distance = view_scores.flatten.max
p max_view_distance # p2-> 330786
