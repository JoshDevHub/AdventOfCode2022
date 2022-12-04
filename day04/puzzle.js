const fs = require("fs");
const readlines = (path) => {
  return fs
    .readFileSync(path, { encoding: 'utf8' })
    .slice(0, -1)
    .split("\n");
}

const rangeInput = readlines(process.argv[2]).map((line) => {
  const arr = [];
  line.replace(/\d+/g, (matched) => arr.push(Number(matched)));
  return arr;
})

const subsetCount = rangeInput.reduce((count, section) => {
  const [lMin, lMax, rMin, rMax] = section;
  if ((lMin >= rMin && lMax <= rMax) || (rMin >= lMin && rMax <= lMax)) {
    return count + 1;
  }
  return count;
}, 0)

const overlapCount = rangeInput.reduce((count, section) => {
  const [lMin, , rMin] = section;
  const [r1, r2] = [...section].sort((a, b) => a - b);
  if ((lMin === r1 || lMin === r2) && (rMin === r1 || rMin === r2)) {
    return count + 1;
  }
  return count;
}, 0)

console.log(subsetCount); // part 1

console.log(overlapCount); // part 2
