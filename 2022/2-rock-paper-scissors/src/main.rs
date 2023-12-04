/*
* Appreciative of your help yesterday, one Elf gives you an encrypted strategy guide (your puzzle input) that
* they say will be sure to help you win. "The first column is what your opponent is going to play: A for Rock,
* B for Paper, and C for Scissors. The second column--" Suddenly, the Elf is called away to help with someone's tent.

The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for
Scissors. Winning every time would be suspicious, so the responses must have been carefully chosen.

The winner of the whole tournament is the player with the highest score. Your total score is the sum of your scores
for each round. The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3
for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).

Since you can't be sure if the Elf is trying to help you or trick you, you should calculate the score you would get
if you were to follow the strategy guide.

For example, suppose you were given the following strategy guide:

A Y
B X
C Z

This strategy guide predicts and recommends the following:

    In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win
    for you with a score of 8 (2 because you chose Paper + 6 because you won).

    In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss
    for you with a score of 1 (1 + 0).
    The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.

In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).
*
* */
use std::collections::HashMap;
use std::env;
use std::fs;

// this function is always done from the perspective of the guide
fn determine_winner<'a>(guide_move: &'a str, enemy_move: &'a str) -> &'a str {
    let translate_enemy = HashMap::from([("A", "rock"), ("B", "paper"), ("C", "scissors")]);
    let translate_guide = HashMap::from([("X", "rock"), ("Y", "paper"), ("Z", "scissors")]);
    let translate_winner = HashMap::from([
        ("rock", "paper"),
        ("paper", "scissors"),
        ("scissors", "rock"),
    ]);

    if translate_guide[guide_move] == translate_enemy[enemy_move] {
        return "draw";
    }

    if translate_winner[translate_guide[guide_move]] == translate_enemy[enemy_move] {
        return "loss";
    }

    return "win";
}

fn compute_points_for_choice_and_result<'a>(guide_move: &'a str, enemy_move: &'a str) -> i32 {
    let winner = match determine_winner(guide_move, enemy_move) {
        "win" => 6,
        "draw" => 3,
        "loss" => 0,
        &_ => 0,
    };

    let choice = match guide_move {
        "X" => 1,
        "Y" => 2,
        "Z" => 3,
        &_ => 0,
    };

    return winner + choice;
}

fn compute_points_for_guide<'a>(guide: &'a str) -> i32 {
    return guide
        .split("\n")
        .collect::<Vec<&'a str>>()
        .into_iter()
        .map(|guide_line| -> i32 {
            let choices = guide_line.split(" ").collect::<Vec<&'a str>>();
            return compute_points_for_choice_and_result(choices[1], choices[0]);
        })
        .sum();
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() <= 2 {
        panic!("Missing file to read and load. Supply the first argument as the file to load!");
    }
    let path = args[2].clone();
    let data = fs::read_to_string(path).expect("Unable to read file");
    let points = compute_points_for_guide(&data.trim());
    println!("Points received: {points}")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_draw() {
        assert_eq!(determine_winner("X", "A"), "draw");
    }
    #[test]
    fn test_win() {
        assert_eq!(determine_winner("X", "C"), "win");
    }
    #[test]
    fn test_loss() {
        assert_eq!(determine_winner("X", "B"), "loss");
    }

    #[test]
    fn test_points_for_win() {
        assert_eq!(compute_points_for_choice_and_result("Y", "A"), 8);
    }

    #[test]
    fn test_points_for_draw() {
        assert_eq!(compute_points_for_choice_and_result("X", "B"), 1);
    }

    #[test]
    fn test_points_for_loss() {
        assert_eq!(compute_points_for_choice_and_result("Z", "C"), 6);
    }

    #[test]
    fn test_total_guide_points() {
        assert_eq!(
            compute_points_for_guide(
                "A Y
B X
C Z"
            ),
            15
        );
    }
}
