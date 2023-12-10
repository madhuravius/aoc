import { Almanac } from "./types";

const sequencedKeys = [
  "soil_to_seed_map",
  "soil_to_fertilizer_map",
  "fertilizer_to_water_map",
  "water_to_light_map",
  "light_to_temperature_map",
  "temperature_to_humidity_map",
  "humidity_to_location_map",
];

export const runSeedThroughEngine = (
  seedNumber: number,
  almanac: Almanac,
): number =>
  sequencedKeys.reduce(
    (accumulator, step) =>
      // @ts-ignore - ignoring below line because we KNOW we have these methods
      // available in sequence above that map to Almanac methods
      almanac[step].getMapping(accumulator),
    seedNumber,
  );

export const findLowestSeed = (almanac: Almanac): number =>
  Math.min(...almanac.seeds.map((seed) => runSeedThroughEngine(seed, almanac)));
