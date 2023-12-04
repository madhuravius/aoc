/*
*
There's no such thing as "points". Instead, scratchcards only cause you to win
more scratchcards equal to the number of winning numbers you have.

Specifically, you win copies of the scratchcards below the winning card equal to the
number of matches. So, if card 10 were to have 5 matching numbers, you would win one
copy each of cards 11, 12, 13, 14, and 15.

Copies of scratchcards are scored like normal scratchcards and have the same card number
as the card they copied. So, if you win a copy of card 10 and it has 5 matching numbers,
it would then win a copy of the same cards that the original card 10 won: cards 11, 12, 13, 14, and 15.
This process repeats until none of the copies cause you to win any more cards. (Cards will never
make you copy a card past the end of the table.)

This time, the above example goes differently:

Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11

    Card 1 has four matching numbers, so you win one copy each of the next four cards: cards 2, 3, 4, and 5.
    Your original card 2 has two matching numbers, so you win one copy each of cards 3 and 4.
    Your copy of card 2 also wins one copy each of cards 3 and 4.
    Your four instances of card 3 (one original and three copies) have two matching numbers, so you
    win four copies each of cards 4 and 5.
    Your eight instances of card 4 (one original and seven copies) have one matching number, so you win eight copies of card 5.
    Your fourteen instances of card 5 (one original and thirteen copies) have no matching numbers and win no more cards.
    Your one instance of card 6 (one original) has no matching numbers and wins no more cards.

Once all of the originals and copies have been processed, you end up with 1 instance of card 1, 2 instances
of card 2, 4 instances of card 3, 8 instances of card 4, 14 instances of card 5, and 1 instance of card 6.
In total, this example pile of scratchcards causes you to ultimately have 30 scratchcards!

*/
use std::env;
use std::fs;

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
