use std::env;
use std::fs;

// https://adventofcode.com/2025/day/4

#[derive(Debug, Default, Clone)]
struct PaperRoll {
    x: i32,
    y: i32,
    can_lift: bool,
}

#[derive(Debug, Default, Clone)]
struct Floor {
    data: Vec<Vec<String>>,
    paper_rolls: Vec<PaperRoll>,
}

const POSITIONS_TO_LOOK: [[i32; 2]; 8] = [
    // left vertical
    [-1, -1],
    [-1, 0],
    [-1, 1],
    // above
    [0, -1],
    // below
    [0, 1],
    // right vertical
    [1, -1],
    [1, 0],
    [1, 1],
];

impl Floor {
    fn new<'a>(floor_data: &'a str) -> Floor {
        parse_floor_data(floor_data)
    }

    fn process_data(&mut self) {
        let mut paper_rolls: Vec<PaperRoll> = vec![];
        self.data
            .clone()
            .into_iter()
            .enumerate()
            .for_each(|(y_idx, row)| {
                row.clone()
                    .into_iter()
                    .enumerate()
                    .for_each(|(x_idx, tile)| {
                        let related_locations = POSITIONS_TO_LOOK
                            .into_iter()
                            .map(|[x_look, y_look]| {
                                let new_x = (x_idx as i32) + x_look;
                                let new_y = (y_idx as i32) + y_look;
                                new_x >= 0
                                    && new_y >= 0
                                    && (new_y as usize) < self.data.len()
                                    && (new_x as usize) < row.len()
                                    && tile == "@"
                                    && self.data[new_y as usize][new_x as usize] == "@"
                            })
                            .filter(|&v| v)
                            .count();
                        if tile == "@" {
                            paper_rolls.push(PaperRoll {
                                x: x_idx as i32,
                                y: y_idx as i32,
                                can_lift: related_locations <= 3,
                            })
                        }
                    })
            });
        self.paper_rolls = paper_rolls;
    }

    fn liftable_rolls(&mut self) -> i32 {
        self.paper_rolls
            .clone()
            .iter()
            .filter(|p| p.can_lift)
            .count() as i32
    }
}

fn parse_floor_data<'a>(floor_data: &'a str) -> Floor {
    let data = floor_data
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
    Floor {
        data,
        paper_rolls: vec![],
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let mut floor = Floor::new(&data.trim());
    println!("loaded floor");
    floor.process_data();
    println!("total liftable rolls: {}", floor.liftable_rolls())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generate_floor_data() {
        let mut floor = Floor::new(
            "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.",
        );
        floor.process_data();
        assert_eq!(10, floor.data.len() as u32);
        assert_eq!(71, floor.paper_rolls.len() as u32);
        assert_eq!(13, floor.liftable_rolls());
    }
}
