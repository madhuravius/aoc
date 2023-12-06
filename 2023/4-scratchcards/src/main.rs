use std::env;
use std::fs;

// https://adventofcode.com/2023/day/4

struct Cards {
    cards: Box<[Card]>,
}

impl Cards {
    fn new<'a>(cards_data: &'a str) -> Cards {
        parse_cards_data(cards_data)
    }

    fn generate_sum(&self) -> i32 {
        self.cards
            .iter()
            .map(|card| card.compute_card_points())
            .sum()
    }
}

struct Card {
    winning_numbers: Box<[i32]>,
    player_numbers: Box<[i32]>,
}

impl Card {
    fn compute_card_points(&self) -> i32 {
        self.player_numbers
            .iter()
            .fold(vec![], |mut acc, player_number| {
                if self.winning_numbers.contains(&player_number) {
                    acc.push(player_number);
                }
                acc
            })
            .iter()
            .enumerate()
            .fold(0, |acc, (idx, _)| {
                if idx == 0 {
                    // avoid double coutning on the first run
                    return 1;
                }
                acc * 2
            })
    }

    fn new<'a>(card_data: &'a str) -> Card {
        parse_row_to_card(card_data)
    }
}

fn parse_row_to_card<'a>(card_data: &'a str) -> Card {
    let row_id_numbers_split = card_data.split(": ").collect::<Vec<&'a str>>();
    let all_numbers = row_id_numbers_split[1]
        .split(" | ")
        .collect::<Vec<&'a str>>();
    let winning_numbers = extract_numbers_from_spaced_list(all_numbers[0]);
    let player_numbers = extract_numbers_from_spaced_list(all_numbers[1]);
    Card {
        winning_numbers,
        player_numbers,
    }
}

fn parse_cards_data<'a>(cards_data: &'a str) -> Cards {
    let cards = cards_data
        .split("\n")
        .collect::<Vec<&'a str>>()
        .iter()
        .map(|card_data| Card::new(card_data))
        .collect();
    Cards { cards }
}

fn extract_numbers_from_spaced_list<'a>(spaced_numbers: &'a str) -> Box<[i32]> {
    spaced_numbers
        .split(" ")
        .collect::<Vec<&'a str>>()
        .into_iter()
        .filter(|&possible_number_as_str| !possible_number_as_str.is_empty())
        .map(|number_as_str| -> i32 { number_as_str.parse::<i32>().unwrap() })
        .collect()
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let cards_sum = Cards::new(&data.trim()).generate_sum();
    println!("Points received: {cards_sum}")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generate_cards_and_generate_sum() {
        let cards = Cards::new(
            "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
        );
        assert_eq!(cards.cards.len(), 6);
        assert_eq!(cards.generate_sum(), 13);
    }

    #[test]
    fn generate_card() {
        let card = Card::new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53");
        let winning_numbers: Box<[i32]> = vec![41, 48, 83, 86, 17].into_boxed_slice();
        let player_numbers: Box<[i32]> = vec![83, 86, 6, 31, 17, 9, 48, 53].into_boxed_slice();
        assert_eq!(card.winning_numbers, winning_numbers);
        assert_eq!(card.player_numbers, player_numbers);
    }

    #[test]
    fn test_card_worth_with_points() {
        let card = Card::new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53");
        assert_eq!(card.compute_card_points(), 8);
    }

    #[test]
    fn test_card_worth_without_points() {
        let card = Card::new("Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36");
        assert_eq!(card.compute_card_points(), 0);
    }
}
