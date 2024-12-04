use std::env;
use std::fs;

// https://adventofcode.com/2024/day/4

struct Grid<'a> {
    data: Vec<Vec<&'a str>>,
}

impl Grid<'_> {
    fn new<'a>(data: &'a str) -> Grid {
        parse_grid_data(data)
    }

    fn count_regulars(&self) -> i32 {
        let directions = [
            // tetris quads
            (0, 1),  // right
            (1, 0),  // down
            (0, -1), // left
            (-1, 0), // up
            // diagonals
            (1, 1),   // down and right
            (1, -1),  // down and left
            (-1, 1),  // up and right
            (-1, -1), // up and left
        ];

        let mut count = 0;
        for y in 0..self.data.len() {
            for x in 0..self.data[y].len() {
                for &(dx, dy) in &directions {
                    if self.check_regular_word(x, y, dx, dy) {
                        count += 1;
                    }
                }
            }
        }
        count
    }

    fn check_regular_word(&self, x: usize, y: usize, dx: isize, dy: isize) -> bool {
        let xmas = vec!["X", "M", "A", "S"];
        let mut x_pos = x as isize;
        let mut y_pos = y as isize;

        for letter in xmas {
            if x_pos < 0
                || y_pos < 0
                || x_pos >= self.data.len() as isize
                || y_pos >= self.data[0].len() as isize
            {
                return false;
            }
            if self.data[x_pos as usize][y_pos as usize] != letter {
                return false;
            }
            x_pos += dx;
            y_pos += dy;
        }

        true
    }

    fn count_bigs(&self) -> i32 {
        let mut count = 0;
        for y in 0..self.data.len() {
            for x in 0..self.data[y].len() {
                if self.data[y][x] != "A" {
                    // really only happens on the "A" center pieces
                    continue;
                }
                if self.check_big(x, y) {
                    println!("Found big XMAS at ({x}, {y})");
                    count += 1;
                }
            }
        }
        count
    }

    fn check_big(&self, x: usize, y: usize) -> bool {
        let big_xmas = vec![vec!["M", "A", "S"], vec!["S", "A", "M"]];

        if x == 0 || y == 0 || x >= self.data.len() - 1 || y >= self.data[0].len() - 1 {
            return false;
        }

        big_xmas
            .iter()
            .any(|mas| *mas == vec![self.data[y - 1][x - 1], "A", self.data[y + 1][x + 1]])
            && big_xmas
                .iter()
                .any(|mas| *mas == vec![self.data[y + 1][x - 1], "A", self.data[y - 1][x + 1]])
    }
}

fn parse_grid_data<'a>(raw_data: &'a str) -> Grid {
    let data: Vec<Vec<&'a str>> = raw_data
        .lines()
        .map(|line| line.split("").filter(|&s| !s.is_empty()).collect())
        .collect();

    Grid { data }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let grid = Grid::new(&data.trim());
    println!("{:?}", grid.data);

    let xmas_count = grid.count_regulars();
    println!("XMAS count: {xmas_count}");

    let big_xmas_count = grid.count_bigs();
    println!("BIG XMAS count: {big_xmas_count}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generate_grid_and_parse() {
        let grid = Grid::new(
            "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX",
        );
        assert_eq!(grid.data.len(), 10);
        assert_eq!(
            grid.data[0],
            vec!["M", "M", "M", "S", "X", "X", "M", "A", "S", "M"]
        );
        assert_eq!(grid.count_regulars(), 18);
        assert_eq!(grid.count_bigs(), 9);
    }
}
