import { expect, test } from "bun:test";
import { readFileSync } from "fs";
import {
  generateSeedRangeFromString,
  parseAlmanac,
  parseDocumentGroup,
  parseEntries,
} from "./parser";

test("parser for seeds themselves", () => {
  expect(generateSeedRangeFromString("79 14 55 13")).toEqual([
    {
      start_range: 79,
      end_range: 93,
      original_range_size: 14,
    },
    {
      start_range: 55,
      end_range: 68,
      original_range_size: 13,
    },
  ]);
});

test("range entry data parsed", () => {
  expect(
    parseEntries(`50 98 2
52 50 48`),
  ).toEqual([
    {
      destination_range_start: 50,
      source_range_start: 98,
      range_length: 2,
    },
    {
      destination_range_start: 52,
      source_range_start: 50,
      range_length: 48,
    },
  ]);
});

test("single document group with mapping parsed", () => {
  const parsedSeedToSoilMap = parseDocumentGroup(`50 98 2
52 50 48`);
  expect(parsedSeedToSoilMap.data).toEqual([
    {
      destination_range_start: 50,
      source_range_start: 98,
      range_length: 2,
    },
    {
      destination_range_start: 52,
      source_range_start: 50,
      range_length: 48,
    },
  ]);
  expect(parsedSeedToSoilMap.getMapping(50)).toEqual(52);
  expect(parsedSeedToSoilMap.getMapping(97)).toEqual(99);
  expect(parsedSeedToSoilMap.getMapping(98)).toEqual(50);
  expect(parsedSeedToSoilMap.getMapping(99)).toEqual(51);
});

test("almanac parsed", () => {
  const parsedAlmanac = parseAlmanac(
    readFileSync("fixtures/test-input.txt", "utf-8"),
  );
  expect(parsedAlmanac.seeds).toEqual([
    {
      start_range: 79,
      end_range: 93,
      original_range_size: 14,
    },
    {
      start_range: 55,
      end_range: 68,
      original_range_size: 13,
    },
  ]);
});
