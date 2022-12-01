# frozen_string_literal: true

input = File.read(*ARGV).split("\n\n")
group_totals = input.reduce([]) do |totals, elf_snacks|
  totals << elf_snacks.split.sum(&:to_i)
end

p group_totals.max # p1-> 68802

p group_totals.max(3).sum # p2-> 205370
