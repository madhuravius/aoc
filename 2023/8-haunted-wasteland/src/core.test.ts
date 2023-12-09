import { expect, test } from "bun:test";
import { parseInput } from "./parser";
import { runThroughInstructions } from "./core";

test("check number of steps needed on reading map example 1", () => {
  const { network, instructions } = parseInput(`RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
`);
  expect(runThroughInstructions({instructions, network})).toEqual(2);
});

test("check number of steps needed on reading map example 2", () => {
  const { network, instructions } = parseInput(`LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
`);
  expect(runThroughInstructions({instructions, network})).toEqual(6);
});
