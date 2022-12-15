# frozen_string_literal: true

input = File.readlines(*ARGV, chomp: true)
            .map { |l| l.scan(/\d+|-\d+/).map(&:to_i) }

@sensor_map = input.each_with_object({}) do |(sx, sy, bx, by), map|
  manhattan_dist = (sx - bx).abs + (sy - by).abs
  map[[sx, sy]] = manhattan_dist
end

def merge(intervals)
  intervals.sort_by!(&:first)

  intervals.each_with_object([]) do |(first, last), merged|
    if merged.empty? || merged[-1][1] < first
      merged << [first, last]
    else
      merged[-1][1] = [merged[-1][1], last].max
    end
  end
end

def impossible_beacon_interval_for(row)
  intervals = []

  @sensor_map.each do |sensor, man_dist|
    x, y = sensor
    vert_dist = (y - row).abs

    next if vert_dist >= man_dist

    hori_dist = man_dist - vert_dist
    interval = [x - hori_dist, x + hori_dist]
    intervals << interval
  end
  merge(intervals)
end

def count_impossible_beacon_positions_for(row)
  left, right = impossible_beacon_interval_for(row).flatten
  (left - right).abs
end

p count_impossible_beacon_positions_for(2_000_000) # p1-> 4724228

def find_distress_beacon(search_space)
  search_space.times do |row|
    row_intervals = impossible_beacon_interval_for(row)

    if row_intervals.length > 1
      distress_beacon_x = row_intervals[0][1]
      return (distress_beacon_x * 4_000_000) + row
    end
  end
end

p find_distress_beacon(4_000_000) # p2-> 13622251246513
