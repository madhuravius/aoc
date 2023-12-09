import sys
from typing import List

# https://adventofcode.com/2021/day/2

class Submarine:
    lines: List[str]
    x: int
    y: int

    def __init__(self, input_string: str) -> None:
        self.lines = input_string.split("\n")
        self.x = 0
        self.y = 0
        for line in self.lines:
            self.final_position_product(line)

    def final_position_product(self, line: str) -> None:
        parsed_line = line.split(" ")
        direction, units = parsed_line[0], int(parsed_line[1])
        # note inverted direction because we're going up in depth
        match(direction):
            case "forward":
                self.x += units
            case "backwards":
                self.x -= units
            case "up":
                self.y -= units
            case "down":
                self.y += units


    def generate_product(self) -> int:
        return self.x * self.y


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
        print(Submarine(file_data).generate_product())
