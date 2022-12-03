const fs = require('fs');
const readFile = (path) => fs.readFileSync(path, { encoding: 'utf8' });

const input = readFile(process.argv[2]).slice(0, -2).split("\n");

const errorChars = input.map((sack) => {
  const midPoint = Math.floor(sack.length / 2);
  const leftHalf = sack.slice(0, midPoint)
  const rightHalf = sack.slice(midPoint)
  return [...leftHalf].find((comp) => rightHalf.includes(comp));
})

const badgeChars = [];
for (let i = 0; i < input.length; i += 3) {
  const [first, second, third] = [input[i], input[i + 1], input[i + 2]]
  const char = [...first].find((sack) => second.includes(sack) && third.includes(sack));
  badgeChars.push(char);
}

const calculatePriority = (charList) => {
  return charList.reduce((sum, curr) => {
    if (!curr) return sum;
    const ascii = curr.charCodeAt();
    const value = ascii - (ascii >= 97 ? 96 : 38)
    return sum + value;
  }, 0)
}

console.log(calculatePriority(errorChars)); // Part1
console.log(calculatePriority(badgeChars)); // Part2
