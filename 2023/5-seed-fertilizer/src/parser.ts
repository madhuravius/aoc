/*
 *Every type of seed, soil, fertilizer and so on is identified with a number, 
 but numbers are reused by each category - that is, soil 123 and fertilizer 123 
 aren't necessarily related to each other.

For example:

seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4

 * */

import { MapRangeEntry, Almanac, MapRangeData } from "./types";

// used to parse seeds
export const generateSeedRangeFromString = (input: string): number[] =>
  input
    .split(" ")
    .map((num) => parseInt(num, 10))
    .filter((elem) => !isNaN(elem));

// this is used for parsing multiline blocks, don't use for seeds
export const parseEntries = (input: string): MapRangeEntry[] =>
  // break up the lines
  input
    .split("\n")
    .map((line) =>
      // within each line, split it up further by digit
      line
        .split(" ")
        .map((num) => parseInt(num)),
    )
    .map((preprocessedLine: number[]) => ({
      destination_range_start: preprocessedLine[0],
      source_range_start: preprocessedLine[1],
      range_length: preprocessedLine[2],
    }));

export const parseDocumentGroup = (input: string): MapRangeData => {
  const data = parseEntries(input);
  return {
    data,
    getMapping: (source: number): number => {
      // go through each source block + range and see if it's there
      for (const {
        destination_range_start: destinationRangeStart,
        source_range_start: sourceRangeStart,
        range_length: rangeLength,
      } of data) {
        if (
          source >= sourceRangeStart &&
          source <= sourceRangeStart + rangeLength
        ) {
          // found! let's return a computed destination equivalent
          return destinationRangeStart + (source - sourceRangeStart);
        }
      }
      return source;
    },
  };
};

export const parseAlmanac = (input: string): Almanac => {
  // document is broken up by double new lines
  const documentGroups = input.split("\n\n");

  const almanac: Almanac = {
    seeds: generateSeedRangeFromString(documentGroups[0]),
    soil_to_seed_map: parseDocumentGroup(documentGroups[1]),
    soil_to_fertilizer_map: parseDocumentGroup(documentGroups[2]),
    fertilizer_to_water_map: parseDocumentGroup(documentGroups[3]),
    water_to_light_map: parseDocumentGroup(documentGroups[4]),
    light_to_temperature_map: parseDocumentGroup(documentGroups[5]),
    temperature_to_humidity_map: parseDocumentGroup(documentGroups[6]),
    humidity_to_location_map: parseDocumentGroup(documentGroups[7]),
  };

  return almanac;
};
