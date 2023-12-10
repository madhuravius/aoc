import { expect, test } from "bun:test";
import { findLowestSeed } from "./almanac";
import { readFileSync } from "fs";
import { parseAlmanac } from "./parser";

test("almanac can find lowest seed as in test cases provided", () => {
  const almanac = parseAlmanac(
    readFileSync("fixtures/test-input.txt", "utf-8"),
  );
  expect(findLowestSeed(almanac)).toEqual(46);
});
