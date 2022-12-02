const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const rpsMap =
  new Map([
    ["X", ["B", "A", "C"]],
    ["Y", ["C", "B", "A"]],
    ["Z", ["A", "C", "B"]]
])

const input = readFile(process.argv[2])
                .slice(0, -1)
                .split("\n")
                .map((l) => l.split(" "));

const calculateScores = (input) => {
  const scores = input.map((set) => {
    const [opponent, self] = set;
    const resultBonus = rpsMap.get(self).indexOf(opponent);
    const moveBonus = ["X", "Y", "Z"].indexOf(self) + 1;
    return moveBonus + 3 * resultBonus;
  });
  return scores.reduce((a, c) => a + c, 0);
}

const p2Input = input.map((set) => {
  const [opponent, self] = set;
  const newMove = [...rpsMap.entries()].find((m) => {
    const idx = ["X", "Y", "Z"].indexOf(self);
    return m[1][idx] === opponent ? m[0] : false
  })
  return [opponent, newMove[0]];
})

const p1 = calculateScores(input)
console.log(p1);

const p2 = calculateScores(p2Input)
console.log(p2);
