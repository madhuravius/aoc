use std::collections::HashSet;
use std::env;
use std::fs;

// https://adventofcode.com/2022/day/6

fn compute_first_marker_after_character<'a>(message: &'a str) -> i32 {
    let mut counter = 0;
    let mut last_four_characters = vec!["?", "?", "?", "?"];
    let letters = message.split("").collect::<Vec<&'a str>>();
    for letter in letters.iter() {
        last_four_characters.remove(0);
        last_four_characters.push(letter);
        counter += 1;

        if counter > 4 
            && last_four_characters
                .clone()
                .into_iter()
                .collect::<HashSet<&str>>()
                .iter()
                .collect::<Vec<_>>()
                .len()
                == 4
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
        assert_eq!(compute_first_marker_after_character("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), 7);
        assert_eq!(compute_first_marker_after_character("bvwbjplbgvbhsrlpgdmjqwftvncz"), 5);
        assert_eq!(compute_first_marker_after_character("nppdvjthqldpwncqszvftbrmjlhg"), 6);
        assert_eq!(compute_first_marker_after_character("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 10);
        assert_eq!(compute_first_marker_after_character("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 11);
    }
}
