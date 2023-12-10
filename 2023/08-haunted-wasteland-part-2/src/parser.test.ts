import { expect, test } from "bun:test";
import { parseInput } from "./parser";

test("parser for map instructions (1 ghost)", () => {
  const { network, instructions } = parseInput(`RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
`);
  expect(instructions).toEqual(["R", "L"]);
  expect(Object.keys(network.nodes).length).toEqual(7);
  expect(Object.keys(network.heads).length).toEqual(1);
});

test("parser for ghost map instructions (2 ghosts)", () => {
  const { network, instructions } = parseInput(`RL

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
`);
  expect(instructions).toEqual(["R", "L"]);
  expect(Object.keys(network.nodes).length).toEqual(8);
  expect(Object.keys(network.heads).length).toEqual(2);
});
