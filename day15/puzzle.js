const fs = require("fs");
const readLines = (path) => {
  return fs
    .readFileSync(path, { encoding: "utf8" })
    .split("\n")
    .filter(Boolean)
    .map((line) => line.match(/-?\d+/g).map(Number));
}

const sensorMap = readLines(process.argv[2]).reduce((map, line) => {
  const [sx, sy, bx, by] = line;
  const manhattanDist = Math.abs(sx - bx) + Math.abs(sy - by);
  map.set([sx, sy], manhattanDist);
  return map;
}, new Map());

const merge = (intervals) => {
  intervals.sort((a, b) => a[0] - b[0]);

  return intervals.reduce((merged, interval) => {
    const [first, last] = interval
    if (merged.length === 0 || merged.at(-1)[1] < first) {
      merged.push([first, last]);
    } else {
      merged.at(-1)[1] = Math.max(merged.at(-1)[1], last);
    }
    return merged;
  }, [])
}

const impossibleIntervalFor = (row) => {
  const intervals = [];

  for (const [[x, y], manDist] of sensorMap) {
    const vertDist = Math.abs(y - row);
    if (vertDist >= manDist) continue;

    const horiDist = manDist - vertDist;
    const interval = [x - horiDist, x + horiDist];
    intervals.push(interval);
  }
  return merge(intervals);
}

const countImpossibleBeaconPositionsFor = (row) => {
  const [left, right] = impossibleIntervalFor(row).flat()
  return Math.abs(left - right);
}

console.log(countImpossibleBeaconPositionsFor(2_000_000)); // Part1

const findDistressBeacon = (searchSize) => {
  for (let row = 0; row < searchSize; row++) {
    const rowIntervals = impossibleIntervalFor(row);

    if (rowIntervals.length > 1) {
      const distressBeaconX = rowIntervals[0][1];
      return (distressBeaconX * 4_000_000) + row;
    }
  }
}

console.log(findDistressBeacon(4_000_000)); // Part2
