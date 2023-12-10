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

export const findLowestSeed = (almanac: Almanac): number => {
  let minimumLocationValueFound: number = -1;
  let seedsProcessed = 0;
  almanac.seeds.forEach((seed, seedIdx) => {
    for (let i = seed.start_range; i < seed.end_range; i++) {
      if (seedsProcessed % 10000000 === 0) {
        console.log(
          `Processed ${seedsProcessed.toLocaleString()} seeds on seed range ${seedIdx}. Current minimum is ${minimumLocationValueFound}.`,
        );
      }

      const locationValue = runSeedThroughEngine(i, almanac);
      if (
        locationValue < minimumLocationValueFound ||
        minimumLocationValueFound === -1
      )
        minimumLocationValueFound = locationValue;
      seedsProcessed += 1;
    }
  });
  return minimumLocationValueFound;
};
