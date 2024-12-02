import sys
from typing import Dict, List, Tuple

# https://adventofcode.com/2024/day/1

def get_lists_from_data(inputs: str) -> Tuple[List[int], List[int], Dict[int, int]]:
    list_one = []
    list_two = []
    map_of_values_in_two = {}
    for line in inputs.split("\n"):
        if line == "":
            continue
        list_one.append(int(line.split("  ")[0]))
        second_value = int(line.split("  ")[1])
        list_two.append(second_value)
        if second_value in map_of_values_in_two:
            map_of_values_in_two[second_value] += 1
        else:
            map_of_values_in_two[second_value] = 1
    return list_one, list_two, map_of_values_in_two

def sum_differences(list_one: List[int], list_two: List[int]) -> int:
    sorted_list_one = sorted(list_one)
    sorted_list_two = sorted(list_two)

    sum = 0
    for idx, _ in enumerate(sorted_list_one):
        sum += (abs(sorted_list_one[idx] - sorted_list_two[idx]))

    return sum


def sum_differences_with_similarity(list_one: List[int], list_two: List[int], map_of_values_in_two: Dict[int, int]) -> int:
    sorted_list_one = sorted(list_one)
    sorted_list_two = sorted(list_two)

    sum = 0
    for idx, elem in enumerate(sorted_list_one):
        if elem in map_of_values_in_two:
            coef = map_of_values_in_two[elem]
        else:
            coef = 0
        sum += (elem * coef)

    return sum

if __name__ == "__main__":
    """
    if file path is supplied, it will read the file to a string, run it through the calibration value loop and return
    get the input from the file supplied on AoC 2024 and save it to data.txt, then run the command with:
    python3 ./main.py data.txt
    """
    if len(sys.argv) < 2:
        raise Exception("Not enough arguments supplied to run")

    with open(sys.argv[1]) as f:
        file_data = str(f.read()).strip()
        print(file_data)
        print("---")
        list_one, list_two, map_of_values_in_two = get_lists_from_data(file_data)
        print(sum_differences(list_one, list_two))
        print(sum_differences_with_similarity(list_one, list_two, map_of_values_in_two))
