use std::env;
use std::fs;

// https://adventofcode.com/2021/day/1

fn compute_measurement_increases<'a>(report: &'a str) -> i32 {
    let mut sum = 0;
    let measurements = report
        .split("\n")
        .map(|i| i.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    measurements
        .clone()
        .into_iter()
        .enumerate()
        .for_each(|(idx, measurement)| {
            if idx > 0 && measurements[idx - 1] < measurement {
                sum += 1
            }
        });
    sum
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let measurement_increases = compute_measurement_increases(&data.trim());
    println!("Measurement increased: {measurement_increases} times")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_compute_measurement_increases() {
        assert_eq!(
            compute_measurement_increases(
                "199
200
208
210
200
207
240
269
260
263"
            ),
            7
        );
    }
}
