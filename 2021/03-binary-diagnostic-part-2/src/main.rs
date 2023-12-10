use std::env;
use std::fs;

// https://adventofcode.com/2021/day/3#part2

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

fn compute_epsilon_and_gamma_digits(
    position: usize,
    input: Vec<Vec<String>>,
) -> (String, String, String) {
    let mut counts_1 = 0;
    let mut counts_2 = 0;
    for line in input.clone() {
        if line[position] == "1" {
            counts_1 += 1;
        } else {
            counts_2 += 1;
        }
    }
    let epsilon_digit = if counts_1 >= counts_2 {
        "0".to_string()
    } else {
        "1".to_string()
    };
    let gamma_digit = if counts_1 >= counts_2 {
        "1".to_string()
    } else {
        "0".to_string()
    };
    let majority = if counts_1 > counts_2 {
        "1".to_string()
    } else if counts_1 < counts_2 {
        "0".to_string()
    } else {
        "-1".to_string()
    };
    (epsilon_digit, gamma_digit, majority)
}

fn compute_oxygen_rates(input: Vec<Vec<String>>) -> String {
    let mut oxygen_rate_candidates = input.clone();
    for (idx, _) in input[0].clone().into_iter().enumerate() {
        let (_, _, majority) =
            compute_epsilon_and_gamma_digits(idx, oxygen_rate_candidates.clone());
        let oxygen_rate = if majority == "1" || majority == "0" {
            majority
        } else {
            "1".to_string()
        };
        let oxygen_rate_candidates_possible = oxygen_rate_candidates
            .clone()
            .into_iter()
            .filter(|candidate| candidate[idx] == oxygen_rate)
            .collect::<Vec<Vec<String>>>();
        if oxygen_rate_candidates_possible.len() != 0 {
            oxygen_rate_candidates = oxygen_rate_candidates_possible;
        }
    }
    return oxygen_rate_candidates.first().unwrap().join("");
}

fn compute_co2_rates(input: Vec<Vec<String>>) -> String {
    let mut co2_rate_candidates = input.clone();
    for (idx, _) in input[0].clone().into_iter().enumerate() {
        let (_, _, majority) = compute_epsilon_and_gamma_digits(idx, co2_rate_candidates.clone());
        let co2_rate = if majority == "1" {
            "0".to_string()
        } else if majority == "0" {
            "1".to_string()
        } else {
            "0".to_string()
        };
        let co2_rate_candidates_possible = co2_rate_candidates
            .clone()
            .into_iter()
            .filter(|candidate| candidate[idx] == co2_rate)
            .collect::<Vec<Vec<String>>>();
        if co2_rate_candidates_possible.len() != 0 {
            co2_rate_candidates = co2_rate_candidates_possible;
        }
    }
    return co2_rate_candidates.first().unwrap().join("");
}

fn compute_epsilon_and_gammarates(input: Vec<Vec<String>>) -> (String, String) {
    let mut epsilon_rate = "".to_string();
    let mut gamma_rate = "".to_string();
    for (idx, _) in input[0].clone().into_iter().enumerate() {
        let (epsilon_digit, gamma_digit, _) = compute_epsilon_and_gamma_digits(idx, input.clone());
        epsilon_rate = format!("{epsilon_rate}{epsilon_digit}");
        gamma_rate = format!("{gamma_rate}{gamma_digit}");
    }
    (epsilon_rate, gamma_rate)
}

fn compute_epsilon_and_gamma_products(input: Vec<Vec<String>>) -> i32 {
    let (epsilon_rate, gamma_rate) = compute_epsilon_and_gammarates(input);
    compute_decimal_from_binary(&epsilon_rate) * compute_decimal_from_binary(&gamma_rate)
}

fn compute_oxygen_and_co2_products(input: Vec<Vec<String>>) -> i32 {
    compute_decimal_from_binary(&compute_oxygen_rates(input.clone()))
        * compute_decimal_from_binary(&compute_co2_rates(input.clone()))
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
    let power_consumption = compute_epsilon_and_gamma_products(parse_data(&data.trim()));
    let life_support_rating = compute_oxygen_and_co2_products(parse_data(&data.trim()));
    println!("Power consumption found to be: {power_consumption}");
    println!("Life support rating found to be: {life_support_rating}");
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
    fn test_compute_rates() {
        assert_eq!(
            compute_epsilon_and_gammarates(parse_data(test_data())),
            ("01001".to_string(), "10110".to_string())
        );
        assert_eq!(
            compute_co2_rates(parse_data(test_data())),
            ("01010".to_string())
        );
        assert_eq!(
            compute_oxygen_rates(parse_data(test_data())),
            ("10111".to_string())
        );
    }

    #[test]
    fn test_compute_products() {
        assert_eq!(
            compute_epsilon_and_gamma_products(parse_data(test_data())),
            198
        );

        assert_eq!(
            compute_oxygen_and_co2_products(parse_data(test_data())),
            230,
        );
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
