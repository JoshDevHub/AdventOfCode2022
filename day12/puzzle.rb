# frozen_string_literal: true

require "set"

# a point on the graph
class Position
  attr_reader :name, :row, :col
  attr_accessor :predecessor

  def initialize(name, row, col)
    @name = name
    @row = row
    @col = col
    @predecessor = nil
  end

  DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

  def adjacents_on(grid)
    DIRECTIONS.reduce([]) do |adjacents, (dr, dc)|
      adj_r = dr + @row
      adj_c = dc + @col
      next(adjacents) unless adj_r >= 0 && adj_r < grid.length &&
                             adj_c >= 0 && adj_c < grid[0].length &&
                             grid[adj_r][adj_c].elevation <= elevation + 1

      adjacents << grid[adj_r][adj_c]
    end
  end

  def coordinates = [@row, @col]

  def ==(other) = coordinates == other.coordinates

  def destination? = name == "E"

  def elevation
    case name
    when "S" then "a".ord
    when "E" then "z".ord
    else name.ord
    end
  end

  def count_back_to_origin
    pointer = self
    counter = 0
    until pointer.predecessor.nil?
      pointer = pointer.predecessor
      counter += 1
    end
    counter
  end
end

@input = File.readlines(*ARGV, chomp: true).map(&:chars)

def create_graph
  @input.map.with_index do |row, row_i|
    row.map.with_index do |letter, col_i|
      Position.new(letter, row_i, col_i)
    end
  end
end

def search_from(start)
  graph = create_graph
  visit_set = Set.new
  visit_set << start

  queue = [start]
  until queue.any?(&:destination?) || queue.empty?
    current = queue.shift
    current.adjacents_on(graph).each do |adj|
      next if visit_set.include?(adj)

      adj.predecessor = current
      visit_set << adj
      queue << adj
    end
  end
  queue.find(&:destination?)&.count_back_to_origin || -1
end

dummy_graph = create_graph.flatten

s_node = dummy_graph.find { |n| n.name == "S" }
p search_from(s_node) # p1-> 391

a_nodes = dummy_graph.select { |n| n.elevation == 97 }
p a_nodes.map { |a| search_from(a) }.reject(&:negative?).min # p2-> 386
