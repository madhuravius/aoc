import unittest

from main import Disk


class TestDiskParser(unittest.TestCase):
    def test_disk_parser(self):
        with open("./fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            disk = Disk(input=file_data)
            self.assertEqual(len(disk.directories), 4)

    def test_directories_under_size_sum(self):
        with open("./fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            disk = Disk(input=file_data)
            self.assertEqual(disk.find_directories_under_size(max_size=100000), 95437)

if __name__ == '__main__':
    unittest.main()
