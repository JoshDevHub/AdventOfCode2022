const fs = require("fs");
const read = (path) => {
  return fs.readFileSync(path, { encoding: "utf8" });
}

const input = read(process.argv[2]);

const findPacketMarker = (seqLength) => {
  for (let i = 0; i < input.length; i++) {
    const endIdx = i + seqLength
    const slice = input.slice(i, endIdx);
    if (new Set(slice).size === seqLength) {
      return endIdx;
    }
  }
}

console.log(findPacketMarker(4)); // Part1

console.log(findPacketMarker(14)); // Part2
