import itertools
import os
import sys
from typing import List, Tuple

# https://adventofcode.com/2024/day/7

POSSIBLE_OPERATIONS = ["+", "*"]

def execute_op(num_one: int, op: str, num_two: int) -> int:
    if os.getenv("DEBUG"):
        print(f"{num_one} {op} {num_two}")
    if op == "+":
        return num_one + num_two
    elif op == "*":
        return num_one * num_two
    else:
        raise Exception("Invalid operation")

def determine_if_inputs_and_outputs_can_be_made_equal(desired_value: int, inputs: List[int]) -> bool:
    if len(inputs) == 1:
       return True 
    total_possible_ops_for_desired_value = []
    for input_idx, inp in enumerate(inputs):
        if input_idx == 0:
            continue
        input_ops = []
        for op in POSSIBLE_OPERATIONS:
            possible_op = [inputs[input_idx - 1], op, inp]
            if possible_op not in input_ops:
                input_ops.append(possible_op)
        if len(total_possible_ops_for_desired_value) - 1 < input_idx:
            total_possible_ops_for_desired_value.append(input_ops)
        else:
            total_possible_ops_for_desired_value[input_idx].append(input_ops)

    combined_ops = list(itertools.product(*total_possible_ops_for_desired_value))
    found_solution = False
    for combined_op in combined_ops:
        if found_solution:
            return True
        op_sum = 0
        for idx, op in enumerate(combined_op):
            if idx == 0:
                op_sum = execute_op(op[0], op[1], op[2])
            else:
                op_sum = execute_op(op_sum, op[1], op[2])

            if op_sum == desired_value and idx == len(combined_op) - 1:
                if os.getenv("DEBUG"):
                    print(f"Found a solution for {desired_value} with inputs {inputs}")
                return True
        if os.getenv("DEBUG"):
            print(f"{op_sum} = {combined_op}")
    return False


def inputs_and_outputs_can_be_made_equal(desired_values_and_inputs: List[Tuple[int, List[int]]]) -> int:
    results: List[int] = []
    for desired_value, inputs in desired_values_and_inputs:
        if determine_if_inputs_and_outputs_can_be_made_equal(desired_value, inputs):
            results.append(desired_value)
    return sum(results)


def get_inputs_and_outputs(raw_inputs: str) -> List[Tuple[int, List[int]]]:
    desired_values_and_inputs: List[Tuple[int, List[int]]] = []
    for line in raw_inputs.split("\n"):
        if line == "":
            continue
        raw_desired_value, raw_inputs = line.split(": ")
        desired_value = int(raw_desired_value)
        inputs: List[int] = [int(inp) for inp in raw_inputs.split(" ")]
        desired_values_and_inputs.append((desired_value, inputs))

    return desired_values_and_inputs 

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
        desired_values_and_inputs = get_inputs_and_outputs(file_data)
        total_matching_inputs_and_outputs = inputs_and_outputs_can_be_made_equal(desired_values_and_inputs)
        print(f"Total matching inputs and outputs: {total_matching_inputs_and_outputs}")

