import { readFileSync } from "fs";
import { parseSafetyProtocols } from "./src/parser";
import { generateMedianSumOfFilteredSafetyProtocols } from "./src/order";

// https://adventofcode.com/2024/day/5

const args = process.argv.slice(2);

if (args.length === 0) {
	throw "No file supplied to generate data. Ex: bun run ./index.ts data.txt";
}

const fileData = readFileSync(args[0], "utf-8");
const safetyProtocols = parseSafetyProtocols(fileData);

console.log(safetyProtocols);
console.log(`Generated median sum of validated updates: ${generateMedianSumOfFilteredSafetyProtocols(safetyProtocols)}`);
