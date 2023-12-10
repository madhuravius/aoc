import sys
from typing import Dict, List

# https://adventofcode.com/2022/day/7

class Disk:
    current_cursor: List[str] 
    data: str
    directories: Dict[str, int]

    def __init__(self, input: str): 
        self.current_cursor = []
        self.data = input
        self.directories = {}

    def parse_data(self):
        for command in self.data.split("\n"):
            if command.startswith("$ cd"):
                target = command.split()[-1]
                if target == "..":
                    self.current_cursor.pop()

                else:
                    if self.current_cursor:
                        if len(self.current_cursor) > 2:
                            self.current_cursor.append(f"{self.current_cursor[-1]}/{target}")
                        else:
                            self.current_cursor.append(f"{self.current_cursor[-1]}{target}")
                    else:
                        self.current_cursor.append(target)

            elif not command.startswith("$ ls") and not command.startswith("dir"):
                file_size, directory = command.split(" ")
                for directory in self.current_cursor:
                    if directory not in self.directories:
                        self.directories[directory] = int(file_size)
                    else:
                        self.directories[directory] += int(file_size)

    def find_directories_under_size(self, max_size: int) -> int:
        sum = 0
        for directory in self.directories.values():
            if directory <= max_size:
                sum += directory
        return sum

    def find_free_space(self, total_disk: int) -> int:
        return total_disk - self.directories["/"]

    def find_largest_directory_recommended_to_delete(self, desired_space: int, total_disk: int) -> int:
        target_space_to_be_freed = desired_space - self.find_free_space(total_disk)
        for disk_possibly_freed in sorted(self.directories.values()):
            if disk_possibly_freed >= target_space_to_be_freed:
                return disk_possibly_freed
        raise Exception("Unable to find file to clear disk with target requested")



if __name__ == "__main__":
    """
    if file path is supplied, it will read the file to a string, run it through the calibration value loop and return
    get the input from the file supplied on AoC and save it to data.txt, then run the command with:
    python3 ./main.py data.txt
    """
    if len(sys.argv) < 2:
        raise Exception("Not enough arguments supplied to run")

    with open(sys.argv[1]) as f:
        file_data = str(f.read()).strip()
        disk = Disk(file_data)
        disk.parse_data()
        max_size = 100000
        max_disk_size = 70000000
        desired_space = 30000000
        print(f"Total size of those under {max_size} - {disk.find_directories_under_size(max_size=100000)}")
        free_space = disk.find_free_space(total_disk=max_disk_size)
        directory_recommended_size = disk.find_largest_directory_recommended_to_delete(desired_space=desired_space, total_disk=max_disk_size)
        print(f"Largest directory deletable for update to run. Total {free_space} currently free. Can delete {directory_recommended_size} by deleting one target directory to free up space.")
        
