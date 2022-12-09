const fs = require("fs");
const readLines = (path) => {
  return fs
    .readFileSync(path, { encoding: 'utf8' })
    .split("\n")
    .filter(Boolean)
    .map((line) => line.split(" "));
}

const DIRECTIONS = {
  "L": [-1, 0], "R": [1, 0], "U": [0, 1], "D": [0, -1]
}

class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  name() {
    return `${this.x},${this.y}`;
  }

  moveIn(direction) {
    const [dx, dy] = DIRECTIONS[direction];
    this.x += dx;
    this.y += dy;
  }

  keepAdjacencyWith(other) {
    const dx = other.x - this.x;
    const dy = other.y - this.y;
    if (Math.abs(dx) < 2 && Math.abs(dy) < 2) return;

    this.x += dx === 0 ? 0 : Math.floor(dx / Math.abs(dx));
    this.y += dy === 0 ? 0 : Math.floor(dy / Math.abs(dy));
  }
}

const puzzleInput = readLines(process.argv[2] || "input.txt");

const countUniqTailPositions = (knot) => {
  const visitSet = new Set();
  const head = knot[0];
  for (const [dir, steps] of puzzleInput) {
    for (let step = 0; step < Number(steps); step++) {
      head.moveIn(dir);
      knot.forEach((curr, i) => {
        if (i === 0) return;
        curr.keepAdjacencyWith(knot[i - 1])
      });
      visitSet.add(knot.at(-1).name());
    }
  }
  return visitSet.size
}

const shortKnot = [new Point(0, 0), new Point(0, 0)];
console.log(countUniqTailPositions(shortKnot)); // Part1

const longKnot = Array(10).fill(null).map(() => new Point(0, 0));
console.log(countUniqTailPositions(longKnot));  // Part2
