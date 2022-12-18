# frozen_string_literal: true

@input = File.read(*ARGV).chomp.chars

ROCK_FORMATIONS = [
  [%w[# # # #]],
  [
    %w[. # .],
    %w[# # #],
    %w[. # .]
  ],
  [
    %w[. . #],
    %w[. . #],
    %w[# # #]
  ],
  [
    %w[#],
    %w[#],
    %w[#],
    %w[#]
  ],
  [
    %w[# #],
    %w[# #]
  ]
].freeze

class Rock
  attr_reader :row, :col

  def initialize(formation, position)
    @formation = formation

    height = @formation.length
    row, @col = position
    @row = row + 3 + height
  end

  DIRECTIONS = { down: [-1, 0], left: [0, -1], right: [0, 1] }.freeze

  def move(dir)
    dr, dc = DIRECTIONS[dir]
    @row += dr
    @col += dc
    @rested = false
  end

  def at_rest? = @rested
  def settle = @rested = true

  def each_segment_position
    results = []
    @formation.each_with_index do |row, row_i|
      row.each_with_index do |seg, col_i|
        results << [@row - row_i, col_i + @col] if seg == "#"
      end
    end
    results
  end

  def each_segment_if_shifted(dir)
    dr, dc = DIRECTIONS[dir]
    each_segment_position.map do |row, col|
      [row + dr, col + dc]
    end
  end
end

@vertical_chamber = Array.new(7) { Array.new(7) { "." } }
def invalid?(row, col)
  row.negative? || row >= @vertical_chamber.length ||
    col.negative? || col >= @vertical_chamber[0].length
end

INSTRUCTIONS = {
  ">" => :right,
  "<" => :left
}.freeze

@instr = []

def move_rock(rock)
  counter = 0
  until rock.at_rest?
    if counter.odd?
      counter += 1
      next_move = rock.each_segment_if_shifted(:down)
      if next_move.any? { |r, c| invalid?(r, c) || @vertical_chamber[r][c] == "#" }
        rock.settle
        rock.each_segment_position.each { |r, c| @vertical_chamber[r][c] = "#" }
      else
        rock.move(:down)
      end
    else
      counter += 1
      @instr << @input.first
      instruction = INSTRUCTIONS[@input.first]
      @input.rotate!
      next_move = rock.each_segment_if_shifted(instruction)
      next if next_move.any? { |r, c| invalid?(r, c) || @vertical_chamber[r][c] == "#" }

      rock.move(instruction)
    end
  end
end

def find_highest_rock
  @vertical_chamber.rindex { |row| row.include?("#") } || -1
end

def add_segment(high_point)
  return if @vertical_chamber.length > high_point + 8

  @vertical_chamber += [
    %w[. . . . . . .],
    %w[. . . . . . .],
    %w[. . . . . . .],
    %w[. . . . . . .],
    %w[. . . . . . .],
    %w[. . . . . . .],
    %w[. . . . . . .]
  ]
end

cycle_map = {}
height_map = {}

rock_count = 0
cycle_positions = []
loop do
  high_point = find_highest_rock
  height_map[rock_count] = high_point
  add_segment(high_point)
  formation = ROCK_FORMATIONS[rock_count % 5]
  new_rock = Rock.new(formation, [high_point, 2])

  hash_key = [@vertical_chamber[high_point], formation, @input.clone]
  if cycle_map.key?(hash_key)
    break unless cycle_positions.empty?

    cycle_positions = [cycle_map[hash_key], rock_count]
  else
    cycle_positions.clear
  end
  cycle_map[hash_key] = rock_count
  move_rock(new_rock)
  rock_count += 1
end

rock_count_cyc_start, rock_count_cyc_end = cycle_positions
rocks_per_cycle = rock_count_cyc_end - rock_count_cyc_start

height_at_cyc_start = height_map[rock_count_cyc_start]
height_at_cyc_end = height_map[rock_count_cyc_end]
cycle_height = height_at_cyc_end - height_at_cyc_start

ROCK_TOTAL = 1_000_000_000_000 # change to 2022 for part1
rocks_after_cycle_origin = ROCK_TOTAL - rock_count_cyc_start
height_per_cycle = rocks_after_cycle_origin / rocks_per_cycle
leftover_rocks = rocks_after_cycle_origin % rocks_per_cycle
leftover_height = height_map[leftover_rocks + rock_count_cyc_start]

height = (height_per_cycle * cycle_height) + leftover_height
p height + 1
