import { readFileSync } from "fs";
import { runThroughInstructions } from "./src/core";
import { parseInput } from "./src/parser";

// https://adventofcode.com/2023/day/8

const args = process.argv.slice(2);

if (args.length === 0) {
  throw "No file supplied to generate data. Ex: bun run ./index.ts data.txt";
}

const fileData = readFileSync(args[0], "utf-8");
const steps = runThroughInstructions(parseInput(fileData));
console.log(`Number of steps to take: ${steps}`);
