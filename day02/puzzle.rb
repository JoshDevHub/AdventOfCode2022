# frozen_string_literal: true

MOVES_MAP = {
  "A" => :r, "X" => :r,
  "B" => :p, "Y" => :p,
  "C" => :s, "Z" => :s
}.freeze

RESULT_MAP = {
  r: { r: 3, p: 0, s: 6 },
  p: { r: 6, p: 3, s: 0 },
  s: { r: 0, p: 6, s: 3 }
}.freeze

input = File.readlines(*ARGV, chomp: true)
            .map { |set| set.split.map(&MOVES_MAP) }

def tally_scores(input)
  scores = input.map do |opp_move, self_move|
    move_bonus = RESULT_MAP.keys.find_index(self_move) + 1
    result_bonus = RESULT_MAP[self_move][opp_move]
    move_bonus + result_bonus
  end
  scores.sum
end

p2_input = input.map do |opp_move, self_move|
  desired = RESULT_MAP[:p][self_move]
  self_move = RESULT_MAP[opp_move].key(desired)
  [opp_move, self_move]
end

p tally_scores(input) # p1-> 13005

p tally_scores(p2_input) # p2-> 11373
