import sys
from typing import List

# https://adventofcode.com/2024/day/2

class RedNoseReportRow:
    data: List[int]

    def __init__(self, data: List[int]):
        self.data = data

    def is_safe(self, override: List[int] = []):
        increasing = False
        if not override:
            override = self.data
        for idx, num in enumerate(override):
            if idx == 0:
                continue

            diff = num - override[idx - 1] 

            if diff == 0:
                break

            if idx == 1 and diff > 0:
                increasing = True

            if diff < 0 and increasing: 
                break

            if diff > 0 and not increasing:
                break

            if abs(diff) > 3:
                break
            
            if idx == len(override) - 1:
                return True
        return False

    def is_safe_with_removal(self):
        if self.is_safe():
            return True
        else:
            for idx, _ in enumerate(self.data):
                if idx == len(self.data) - 1:
                    return self.is_safe(override=self.data[:-1])
                elif self.is_safe(override=self.data[:idx] + self.data[idx + 1:]):
                    return True


class RedNoseReport:
    data: List[List[int]]
    raw: str 

    def __init__(self, raw: str):
        self.raw = raw
        self.parse_data()

    def parse_data(self):
        data: List[List[int]] = []
        for raw_row in self.raw.split("\n"):
            if raw_row == "":
                continue
            row = [int(num) for num in raw_row.split(" ")]
            data.append(row)
        self.data = data

    def get_safe_reports(self):
        safe_reports = 0
        for row in self.data:
            row_parsed = RedNoseReportRow(row)
            if row_parsed.is_safe():
                safe_reports += 1
        return safe_reports
    
    def get_safe_reports_with_removals(self):
        safe_reports = 0
        for row in self.data:
            row_parsed = RedNoseReportRow(row)
            if row_parsed.is_safe_with_removal():
                safe_reports += 1
        return safe_reports

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
        reports = RedNoseReport(raw=file_data)
        print(reports.get_safe_reports())
        print(reports.get_safe_reports_with_removals())

