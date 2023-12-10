use std::env;
use std::fs;

// https://adventofcode.com/2023/day/4#part2

#[derive(Debug)]
struct Cards {
    cards: Box<[Card]>,
    uncomputed_outstanding: bool,
}

impl Cards {
    fn new<'a>(cards_data: &'a str) -> Cards {
        parse_cards_data(cards_data)
    }

    fn generate_sum(&mut self) -> i32 {
        // WARNING - this approach is batshit insane, really needs to not make full copies of
        // cards, but probably references to them in a hashmap (all pointers?) with the only
        // new information being if it's been counted or not.
        // This takes 2.5 minutes on a i5 from 2015
        //
        // TODO - instead of recomputing every card, just recompute in order by level
        let original_cards = self.cards.to_vec();
        while self.uncomputed_outstanding {
            let mut cards_in_place = self.cards.to_vec();
            let mut cards_to_add: Vec<Card> = vec![];
            let mut created_childen = false;
            self.cards
                .to_vec()
                .iter_mut()
                .enumerate()
                .for_each(|(idx, card)| -> _ {
                    if !card.computed {
                        card.compute_cards_won();
                        card.won_cards.iter().for_each(|won_card_id| {
                            let card_to_append =
                                original_cards.get((won_card_id - 1) as usize).unwrap();
                            cards_to_add.push(card_to_append.clone());
                            created_childen = true;
                        });
                        cards_in_place[idx] = card.clone();
                    }
                });
            let mut cards_to_save = cards_in_place.to_vec();
            cards_to_save.extend(cards_to_add.iter().cloned());
            self.cards = cards_to_save.into_boxed_slice();
            println!("Up to records: {}", self.cards.len());
            if !created_childen {
                self.uncomputed_outstanding = false;
            }
        }
        self.cards.len() as i32
    }
}

#[derive(Clone, Debug)]
struct Card {
    id: i32,
    winning_numbers: Box<[i32]>,
    player_numbers: Box<[i32]>,
    won_cards: Box<[i32]>,
    computed: bool,
}

impl Card {
    fn compute_cards_won(&mut self) {
        self.won_cards = self
            .player_numbers
            .iter()
            .fold(vec![], |mut acc, player_number| -> _ {
                if self.winning_numbers.contains(&player_number) {
                    acc.push(self.id + acc.len() as i32 + 1);
                }
                acc
            })
            .into_boxed_slice();
        self.set_as_computed();
    }

    fn set_as_computed(&mut self) {
        self.computed = true;
    }

    fn new<'a>(card_data: &'a str) -> Card {
        parse_row_to_card(card_data)
    }
}

fn parse_row_to_card<'a>(card_data: &'a str) -> Card {
    let row_id_numbers_split = card_data.split(": ").collect::<Vec<&'a str>>();
    let id: i32 = row_id_numbers_split[0]
        .split(" ")
        .collect::<Vec<&'a str>>()
        .last()
        .copied()
        .unwrap()
        .parse::<i32>()
        .unwrap();
    let all_numbers = row_id_numbers_split[1]
        .split(" | ")
        .collect::<Vec<&'a str>>();
    let winning_numbers = extract_numbers_from_spaced_list(all_numbers[0]);
    let player_numbers = extract_numbers_from_spaced_list(all_numbers[1]);
    Card {
        id,
        winning_numbers,
        player_numbers,
        won_cards: vec![].into_boxed_slice(),
        computed: false,
    }
}

fn parse_cards_data<'a>(cards_data: &'a str) -> Cards {
    let cards = cards_data
        .split("\n")
        .collect::<Vec<&'a str>>()
        .iter()
        .map(|card_data| Card::new(card_data))
        .collect();
    Cards {
        cards,
        uncomputed_outstanding: true,
    }
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
        let mut cards = Cards::new(
            "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
        );
        assert_eq!(cards.cards.len(), 6);
        assert_eq!(cards.uncomputed_outstanding, true);
        assert_eq!(cards.generate_sum(), 30);
        assert_eq!(cards.uncomputed_outstanding, false);
    }

    #[test]
    fn generate_card() {
        let card = Card::new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53");
        let winning_numbers: Box<[i32]> = vec![41, 48, 83, 86, 17].into_boxed_slice();
        let player_numbers: Box<[i32]> = vec![83, 86, 6, 31, 17, 9, 48, 53].into_boxed_slice();
        assert_eq!(card.id, 1);
        assert_eq!(card.winning_numbers, winning_numbers);
        assert_eq!(card.player_numbers, player_numbers);
    }

    #[test]
    fn test_card_worth_that_will_win_child_cards() {
        let mut card = Card::new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53");
        assert_eq!(card.computed, false);
        card.compute_cards_won();
        assert_eq!(card.won_cards, vec![2, 3, 4, 5].into_boxed_slice());
        assert_eq!(card.computed, true);
    }

    #[test]
    fn test_card_worth_that_will_win_no_child_cards() {
        let mut card = Card::new("Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36");
        assert_eq!(card.computed, false);
        card.compute_cards_won();
        assert_eq!(card.won_cards, vec![].into_boxed_slice());
        assert_eq!(card.computed, true);
    }
}
