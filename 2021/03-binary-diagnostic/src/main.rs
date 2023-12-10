use std::env;
use std::fs;

// https://adventofcode.com/2021/day/3

fn parse_data<'a>(input: &'a str) -> Vec<Vec<String>> {
    input
        .split("\n")
        .map(|line| {
            line.chars()
                .map(|char| char.to_string())
                .into_iter()
                .collect::<Vec<_>>()
        })
        .collect()
}

fn compute_rates(input: Vec<Vec<String>>) -> (String, String) {
    let mut epsilon_rate = "".to_string();
    let mut gamma_rate = "".to_string();
    for (idx, _) in input[0].clone().into_iter().enumerate() {
        let mut counts = 0;
        for line in input.clone() {
            if line[idx] == "1" {
                counts += 1;
            }
        }
        let epsilon_digit = if counts >= (input.len() / 2) {
            "0"
        } else {
            "1"
        };
        let gamma_digit = if counts >= (input.len() / 2) {
            "1"
        } else {
            "0"
        };
        epsilon_rate = format!("{epsilon_rate}{epsilon_digit}");
        gamma_rate = format!("{gamma_rate}{gamma_digit}");
    }
    (epsilon_rate, gamma_rate)
}

fn compute_products(input: Vec<Vec<String>>) -> i32 {
    let (epsilon_rate, gamma_rate) = compute_rates(input);
    compute_decimal_from_binary(&epsilon_rate) * compute_decimal_from_binary(&gamma_rate)
}

fn compute_decimal_from_binary<'a>(input: &'a str) -> i32 {
    let mut decimal = 0;
    input
        .chars()
        .into_iter()
        .rev()
        .enumerate()
        .for_each(|(idx, char)| {
            if char.to_string() == "1" {
                decimal += (2 as i32).pow(idx as u32);
            }
        });
    decimal
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let power_consumption = compute_products(parse_data(&data.trim()));
    println!("Power consumption found to be: {power_consumption}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_compute_decimal_from_binary() {
        assert_eq!(compute_decimal_from_binary("0000"), 0);
        assert_eq!(compute_decimal_from_binary("0001"), 1);
        assert_eq!(compute_decimal_from_binary("0011"), 3);
        assert_eq!(compute_decimal_from_binary("0111"), 7);
        assert_eq!(compute_decimal_from_binary("1011"), 11);
        assert_eq!(compute_decimal_from_binary("1111"), 15);
    }

    #[test]
    fn test_parse_data() {
        assert_eq!(parse_data("01\n10"), vec!(vec!("0", "1"), vec!("1", "0")))
    }

    #[test]
    fn test_compute_gamma_rate() {
        assert_eq!(
            compute_rates(parse_data(test_data())),
            ("01001".to_string(), "10110".to_string())
        );
    }

    #[test]
    fn test_compute_products() {
        assert_eq!(compute_products(parse_data(test_data())), 198);
    }

    fn test_data<'a>() -> &'a str {
        "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"
    }
}
