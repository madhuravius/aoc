import { expect, test } from "bun:test";
import { parseInput } from "./parser";
import { runThroughInstructions } from "./core";

test("check number of steps needed on reading map example 1 (1 ghost)", () => {
  const { network, instructions } = parseInput(`RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
`);
  expect(runThroughInstructions({ instructions, network })).toEqual(2);
});

test("check number of steps needed on reading map example 2 (1 ghost)", () => {
  const { network, instructions } = parseInput(`LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
`);
  expect(runThroughInstructions({ instructions, network })).toEqual(6);
});

test("check number of steps needed on reading map example 3 (2 ghosts)", () => {
  const { network, instructions } = parseInput(`LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
`);
  expect(runThroughInstructions({ instructions, network })).toEqual(6);
});
