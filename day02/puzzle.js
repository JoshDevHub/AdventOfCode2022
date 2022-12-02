const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const movesMap =
  new Map(
    ["A", "r"], ["X", "r"],
    ["B", "p"], ["Y", "p"],
    ["C", "s"], ["Z", "s"]
);

