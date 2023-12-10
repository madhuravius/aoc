use std::collections::HashMap;
use std::env;
use std::fs;

// https://adventofcode.com/2022/day/2#part2

// this function is always done from the perspective of the guide
#[allow(suspicious_double_ref_op)] // used for translated_loser inversion
fn determine_guide_move<'a>(desired_result: &'a str, enemy_move: &'a str) -> &'a str {
    let translate_enemy = HashMap::from([("A", "rock"), ("B", "paper"), ("C", "scissors")]);
    let translate_desired_result = HashMap::from([("X", "loss"), ("Y", "draw"), ("Z", "win")]);
    let translate_winner = HashMap::from([
        ("rock", "paper"),
        ("paper", "scissors"),
        ("scissors", "rock"),
    ]);
    let translate_loser: HashMap<&str, &str> = translate_winner
        .iter()
        .map(|(k, v)| (v.clone(), k.clone()))
        .collect();

    if translate_desired_result[desired_result] == "draw" {
        return translate_enemy[enemy_move];
    }

    if translate_desired_result[desired_result] == "win" {
        return translate_winner[translate_enemy[enemy_move]];
    }

    return translate_loser[translate_enemy[enemy_move]];
}

fn compute_points_for_choice_and_result<'a>(desired_result: &'a str, enemy_move: &'a str) -> i32 {
    let winner = match determine_guide_move(desired_result, enemy_move) {
        "rock" => 1,
        "paper" => 2,
        "scissors" => 3,
        &_ => 0,
    };

    let choice = match desired_result {
        "X" => 0,
        "Y" => 3,
        "Z" => 6,
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
        assert_eq!(determine_guide_move("Y", "A"), "rock");
    }
    #[test]
    fn test_loss() {
        assert_eq!(determine_guide_move("X", "B"), "rock");
    }
    #[test]
    fn test_win() {
        assert_eq!(determine_guide_move("Z", "C"), "rock");
    }
    #[test]
    fn test_points_for_win() {
        assert_eq!(compute_points_for_choice_and_result("Y", "A"), 4);
    }

    #[test]
    fn test_points_for_draw() {
        assert_eq!(compute_points_for_choice_and_result("X", "B"), 1);
    }

    #[test]
    fn test_points_for_loss() {
        assert_eq!(compute_points_for_choice_and_result("Z", "C"), 7);
    }

    #[test]
    fn test_total_guide_points() {
        assert_eq!(
            compute_points_for_guide(
                "A Y
B X
C Z"
            ),
            12
        );
    }
}
