use std::collections::HashSet;
use std::env;
use std::fs;

// https://adventofcode.com/2022/day/6#part2

fn compute_first_marker_after_character<'a>(message: &'a str) -> i32 {
    let mut counter = 0;
    let mut last_characters = vec![];
    let letters = message.split("").collect::<Vec<&'a str>>();
    for letter in letters.iter() {
        if last_characters.len() > 13 {
            last_characters.remove(0);
        }
        last_characters.push(letter);
        counter += 1;

        if last_characters
            .clone()
            .into_iter()
            .collect::<HashSet<_>>()
            .iter()
            .collect::<Vec<_>>()
            .len()
            == 14
        {
            return counter - 1;
        }
    }
    println!("{}", message);
    0
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let marker = compute_first_marker_after_character(&data.trim());
    println!("First market found at: {marker}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_tuning_trouble() {
        assert_eq!(
            compute_first_marker_after_character("mjqjpqmgbljsphdztnvjfqwrcgsmlb"),
            19
        );
        assert_eq!(
            compute_first_marker_after_character("bvwbjplbgvbhsrlpgdmjqwftvncz"),
            23
        );
        assert_eq!(
            compute_first_marker_after_character("nppdvjthqldpwncqszvftbrmjlhg"),
            23
        );
        assert_eq!(
            compute_first_marker_after_character("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"),
            29
        );
        assert_eq!(
            compute_first_marker_after_character("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"),
            26
        );
    }
}
