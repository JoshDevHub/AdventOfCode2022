const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const input = readFile(process.argv[2]).slice(0, -2).split("\n\n");
const sum = (a, b) => Number(a) + Number(b);

const groupTotals = input.reduce((totals, elfSnacks) => {
  const elfTotal = elfSnacks.split("\n").reduce(sum, 0);
  totals.push(elfTotal);
  return totals;
}, []);

console.log(Math.max(...groupTotals)); // p1

const sortedTotals = [...groupTotals].sort((a, b) => b - a);
console.log(sortedTotals.slice(0, 3).reduce(sum, 0)); // p2
