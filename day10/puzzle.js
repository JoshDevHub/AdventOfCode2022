const fs = require("fs");
const puzzleInput = fs.readFileSync(process.argv[2], { encoding: 'utf8' })
                      .split("\n")
                      .filter(Boolean)
                      .map((line) => line.split(" "));

let x = 1;
const xValueCollection = [];

for (const [instruction, value] of puzzleInput) {
  xValueCollection.push(x);
  if (instruction === "noop") continue;

  xValueCollection.push(x)
  x += Number(value);
}

CYCLE_LIST = [220, 180, 140, 100, 60, 20];
const signalStrengths = CYCLE_LIST.reduce((sum, cycle) => {
  return sum + cycle * xValueCollection[cycle];
}, 0)

console.log(signalStrengths); // Part 1

const drawPixelIsInSprite = (drawPx, sprite) => {
  return sprite - 1 <= drawPx && sprite + 1 >= drawPx;
}

const CRT_ROWS = [200, 160, 120, 80, 40];

const flatGrid = Array(240).fill(".");

const crt = flatGrid.map((px, cycle) => {
  const heightCorrection = CRT_ROWS.find((row) => cycle > row - 1) || 0;
  const drawPx = cycle - heightCorrection;

  const currentX = xValueCollection[cycle];
  return drawPixelIsInSprite(drawPx, currentX) ? "#" : px;
})

const crtImage = crt.reduce((output, px, index) => {
  return output + (index % 40 === 0 ? "\n" : "") + px;
})

console.log(crtImage); // Part 2
