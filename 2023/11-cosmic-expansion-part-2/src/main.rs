use std::collections::HashMap;
use std::env;
use std::fs;

// https://adventofcode.com/2023/day/11#part2

#[derive(Debug, Default, Clone)]
struct Galaxy {
    id: i32,
    x: i64,
    y: i64,
}

#[derive(Debug, Default, Clone)]
struct Chart {
    data: Vec<Vec<String>>,
    galaxies: Vec<Galaxy>,
    empty_x: HashMap<i32, bool>,
    empty_y: HashMap<i32, bool>,
}

const MULTIPLIER_FOR_VOID: i64 = 1000000;

impl Chart {
    fn new<'a>(chart_data: &'a str) -> Chart {
        parse_chart_data(chart_data)
    }

    fn process_data(&mut self) {
        self.process_empty_spaces();
        self.process_galaxies();
    }

    fn sum_distances_between_all_pairs_of_galaxies(&mut self) -> i64 {
        self.galaxy_pairs()
            .into_iter()
            .map(|(galaxy_1, galaxy_2): (Galaxy, Galaxy)| -> i64 {
                compute_distance_between_galaxy_pair(galaxy_1, galaxy_2)
            })
            .sum()
    }

    fn process_galaxies(&mut self) {
        let mut galaxies: Vec<Galaxy> = vec![];
        self.data
            .clone()
            .into_iter()
            .enumerate()
            .for_each(|(y_idx, row)| {
                row.into_iter().enumerate().for_each(|(x_idx, tile)| {
                    if tile == "#" {
                        let padded_x = self
                            .empty_x
                            .keys()
                            .filter(|x| (**x as u32) <= (x_idx as u32))
                            .collect::<Vec<_>>()
                            .len();
                        let padded_y = self
                            .empty_y
                            .keys()
                            .filter(|y| (**y as u32) <= (y_idx as u32))
                            .collect::<Vec<_>>()
                            .len();
                        galaxies.push(Galaxy {
                            id: galaxies.len() as i32,
                            x: x_idx as i64
                                + (padded_x * (MULTIPLIER_FOR_VOID - 1) as usize) as i64,
                            y: y_idx as i64
                                + (padded_y * (MULTIPLIER_FOR_VOID - 1) as usize) as i64,
                        });
                    }
                });
            });
        self.galaxies = galaxies;
    }

    fn process_empty_spaces(&mut self) {
        // add padding for y if empty rows
        self.data
            .clone()
            .into_iter()
            .enumerate()
            .for_each(|(y_idx, row)| {
                if !row.clone().into_iter().any(|tile| tile == "#".to_string()) {
                    // add another row if there's meant to be two
                    self.empty_y.insert(y_idx as i32, true);
                }
            });
        // add padding for x if empty cols
        self.data.clone()[0]
            .clone()
            .into_iter()
            .enumerate()
            .for_each(|(x_idx, _)| {
                if self
                    .data
                    .clone()
                    .into_iter()
                    .map(|row| row[x_idx].to_string())
                    .all(|val| val == ".")
                {
                    self.empty_x.insert(x_idx as i32, true);
                }
            });
    }

    fn galaxy_pairs(&mut self) -> Vec<(Galaxy, Galaxy)> {
        let mut galaxy_pairs: Vec<(Galaxy, Galaxy)> = vec![];
        let mut pairs_stored: HashMap<String, bool> = HashMap::new();
        self.galaxies.clone().into_iter().for_each(|galaxy_1| {
            self.galaxies.clone().into_iter().for_each(|galaxy_2| {
                let mut ids: Vec<String> = vec![galaxy_1.id.to_string(), galaxy_2.id.to_string()];
                ids.sort();
                let pair_id_stored = format!("{id1}.{id2}", id1 = ids[0], id2 = ids[1]);
                if galaxy_1.id == galaxy_2.id || pairs_stored.contains_key(&pair_id_stored) {
                    return;
                }

                galaxy_pairs.push((galaxy_1.clone(), galaxy_2.clone()));
                pairs_stored.insert(pair_id_stored, true);
            });
        });
        galaxy_pairs
    }
}

fn compute_distance_between_galaxy_pair(galaxy_1: Galaxy, galaxy_2: Galaxy) -> i64 {
    (galaxy_1.x - galaxy_2.x).abs() + (galaxy_1.y - galaxy_2.y).abs()
}

fn parse_chart_data<'a>(chart_data: &'a str) -> Chart {
    let data = chart_data
        .split("\n")
        .collect::<Vec<&'a str>>()
        .iter()
        .map(|line| {
            line.split("")
                .filter(|&char| !char.is_empty())
                .into_iter()
                .map(|char| char.to_string())
                .collect()
        })
        .collect();
    Chart {
        data,
        galaxies: vec![],
        empty_x: HashMap::new(),
        empty_y: HashMap::new(),
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let mut chart = Chart::new(&data.trim());
    println!("loaded chart");
    chart.process_data();
    let galaxy_count = chart.galaxies.len();
    println!("processed data on {galaxy_count} galaxies");
    let distances = chart.sum_distances_between_all_pairs_of_galaxies();
    println!("Total distance traveled: {distances}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generate_chart_data() {
        let mut chart = Chart::new(
            "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....",
        );
        chart.process_data();
        assert_eq!(chart.data.len() as u32, 10);
        assert_eq!(chart.empty_x.len() as u32, 3);
        assert_eq!(chart.empty_y.len() as u32, 2);
        assert_eq!(chart.galaxies.len() as u32, 9);
    }

    #[test]
    fn generate_galaxy_pairs() {
        let mut chart = Chart::new(
            "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....",
        );
        chart.process_data();
        assert_eq!(chart.galaxy_pairs().len() as u32, 36);
    }

    #[test]
    fn test_compute_distance_between_galaxy_pair() {
        assert_eq!(
            compute_distance_between_galaxy_pair(
                Galaxy { id: 1, x: 5, y: 11 },
                Galaxy { id: 2, x: 1, y: 6 }
            ),
            9
        );
    }
    #[test]
    fn test_compute_distance_between_galaxy_pair_1() {
        assert_eq!(
            compute_distance_between_galaxy_pair(
                Galaxy { id: 1, x: 4, y: 0 },
                Galaxy { id: 2, x: 9, y: 10 }
            ),
            15
        );
    }
    #[test]
    fn test_compute_distance_between_galaxy_pair_2() {
        assert_eq!(
            compute_distance_between_galaxy_pair(
                Galaxy { id: 1, x: 0, y: 2 },
                Galaxy { id: 2, x: 1, y: 6 }
            ),
            5
        );
    }

    #[test]
    fn test_compute_distance_between_galaxy_pair_3() {
        assert_eq!(
            compute_distance_between_galaxy_pair(
                Galaxy { id: 1, x: 0, y: 10 },
                Galaxy { id: 2, x: 5, y: 10 }
            ),
            5
        );
    }

    #[test]
    fn test_sum_distances_between_all_pairs_of_galaxies() {
        let mut chart = Chart::new(
            "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....",
        );
        chart.process_data();
        assert_eq!(
            chart.sum_distances_between_all_pairs_of_galaxies(),
            82000210
        );
    }
}
