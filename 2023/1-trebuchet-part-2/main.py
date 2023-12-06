import sys
from typing import List, Tuple

# https://adventofcode.com/2023/day/1#part2

MAP_OF_WORDS_TO_VALUES = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
    "zero": 0
}
WORD_KEYS = [word_as_num for word_as_num in MAP_OF_WORDS_TO_VALUES.keys()]
LARGEST_WORD_KEY = max([len(word_key) for word_key in WORD_KEYS])


def look_ahead_and_see_if_word_present(input_string: str | List[str], starting_letter: str, idx: int, reverse: bool = False) -> Tuple[str, bool]:
    found_word = False
    possible_word = starting_letter

    while len(possible_word) < LARGEST_WORD_KEY:
        word_to_check = possible_word
        if reverse:
            word_to_check = possible_word[::-1]

        if word_to_check in WORD_KEYS:
            found_word = True 
            break

        if (idx + len(possible_word)) < len(input_string) - 1:
           possible_word += input_string[idx + len(possible_word)]
        else:
            break

    if reverse:
        return possible_word[::-1], found_word

    return possible_word, found_word


def get_digit_from_input_string(input_string: str | List[str], reverse: bool = False) -> int | None:
    digit: int | None = None
    for idx,char in enumerate(input_string):
        found_word = False
        if digit or found_word:
            break
        elif char.isdigit():
            digit = int(char)
            break
        else:
            # look ahead as long as strings are possibly matching
            possible_word, found_word = look_ahead_and_see_if_word_present(
                input_string=input_string,
                starting_letter=char,
                idx=idx,
                reverse=reverse
            )
            if found_word or possible_word in WORD_KEYS:
                digit = MAP_OF_WORDS_TO_VALUES[possible_word]
                found_word = True
    return digit


def calibration_value(input_string: str) -> int:
    first_digit = get_digit_from_input_string(input_string=input_string)
    last_digit = get_digit_from_input_string(input_string=list(reversed(input_string)), reverse=True)

    if first_digit == None or last_digit == None:
        raise Exception("Unable to find digit value to view")

    return int(f"{first_digit}{last_digit}")

def sum_calibration_values(inputs: str) -> int:
    return sum([calibration_value(input_string=input_string) for input_string in inputs.split("\n")])

if __name__ == "__main__":
    """
    if file path is supplied, it will read the file to a string, run it through the calibration value loop and return
    get the input from the file supplied on AoC 2023 and save it to data.txt, then run the command with:
    python3 ./main.py data.txt
    """
    if len(sys.argv) < 2:
        raise Exception("Not enough arguments supplied to run")

    with open(sys.argv[1]) as f:
        file_data = str(f.read()).strip()
        print(file_data)
        print("---")
        print(sum_calibration_values(file_data))
