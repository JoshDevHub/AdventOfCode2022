# frozen_string_literal: true

input = File.readlines(*ARGV, chomp: true).map(&:split)

x = 1
x_at_each_cycle = []

input.each do |ins, v|
  x_at_each_cycle << x
  next if ins == "noop"

  x_at_each_cycle << x
  x += v.to_i
end

CYCLES_LIST = [220, 180, 140, 100, 60, 20].freeze

signal_strengths = CYCLES_LIST.sum { |cycle| cycle * x_at_each_cycle[cycle - 1] }

p signal_strengths # p1-> 17940

def draw_px_in_sprite?(mid_sprite, draw_px)
  mid_sprite - 1 <= draw_px and mid_sprite + 1 >= draw_px
end

CRT_ROWS = [200, 160, 120, 80, 40].freeze

flat_grid = ["."] * 240

crt = flat_grid.map.with_index do |px, cycle|
  height_correction = CRT_ROWS.find { |row| cycle > row - 1 } || 0
  draw_px = cycle - height_correction

  x_val = x_at_each_cycle[cycle]
  draw_px_in_sprite?(x_val, draw_px) ? "#" : px
end

crt.each_slice(40) { |line| puts line.join } # p2-> ZCBAJFJZ
