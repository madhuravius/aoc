import sys

# https://adventofcode.com/2023/day/1

def calibration_value(input_string: str) -> int:
    first_digit: int | None = None
    last_digit: int | None = None

    for char in input_string:
        if char.isdigit():
            first_digit = int(char)
            break
    for char in reversed(input_string):
        if char.isdigit():
            last_digit = int(char)
            break

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
