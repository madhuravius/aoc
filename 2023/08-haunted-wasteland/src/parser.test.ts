import { expect, test } from "bun:test";
import { parseInput } from "./parser";

test("parser for map instructions", () => {
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
});
