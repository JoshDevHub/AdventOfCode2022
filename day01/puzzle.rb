# frozen_string_literal: true

input = File.read(*ARGV).split("\n\n")
group_totals = input.map { |snack_group| snack_group.split.sum(&:to_i) }

p group_totals.max # p1-> 68802

p group_totals.max(3).sum # p2-> 205370
