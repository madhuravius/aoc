export interface MapRangeEntry {
  destination_range_start: number;
  source_range_start: number;
  range_length: number;
}

export type GetMapping = (source: number) => number;
export interface MapRangeData {
  // raw data
  data: MapRangeEntry[];
  // mapped data as specified by ranges
  getMapping: GetMapping;
}

export interface SoilToSeedMap extends MapRangeData {}
export interface SoilToFertilizerMap extends MapRangeData {}
export interface FertilizerToWaterMap extends MapRangeData {}
export interface WaterToLightMap extends MapRangeData {}
export interface LightToTemperatureMap extends MapRangeData {}
export interface TemperatureToHumidityMap extends MapRangeData {}
export interface HumidityToLocationMap extends MapRangeData {}

export interface Almanac {
  seeds: number[];
  soil_to_seed_map: SoilToSeedMap;
  soil_to_fertilizer_map: SoilToFertilizerMap;
  fertilizer_to_water_map: FertilizerToWaterMap;
  water_to_light_map: WaterToLightMap;
  light_to_temperature_map: LightToTemperatureMap;
  temperature_to_humidity_map: TemperatureToHumidityMap;
  humidity_to_location_map: HumidityToLocationMap;
}
