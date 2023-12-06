import { readFileSync } from "fs";
import { parseAlmanac } from "./src/parser";
import { findLowestSeed } from "./src/almanac";

// https://adventofcode.com/2023/day/5#part2

const args = process.argv.slice(2);

if (args.length === 0) {
  throw "No file supplied to generate data. Ex: bun run ./index.ts data.txt";
}

const fileData = readFileSync(args[0], "utf-8");
const almanac = parseAlmanac(fileData);
const lowestSeed = findLowestSeed(almanac);

console.log(`For supplied data with seeds: ${almanac.seeds}`);
console.log(`Lowest value found: ${lowestSeed}`);
