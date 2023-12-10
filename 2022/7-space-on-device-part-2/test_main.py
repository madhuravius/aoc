import unittest

from main import Disk


class TestDiskParser(unittest.TestCase):
    def test_disk_parser(self):
        with open("./fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            disk = Disk(input=file_data)
            disk.parse_data()
            self.assertEqual(len(disk.directories.items()), 4)

    def test_directories_under_size_sum(self):
        with open("./fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            disk = Disk(input=file_data)
            disk.parse_data()
            self.assertEqual(disk.find_directories_under_size(max_size=100000), 95437)

    def test_disk_free_space(self):
        with open("./fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            disk = Disk(input=file_data)
            disk.parse_data()
            self.assertEqual(disk.find_free_space(total_disk=70000000), 21618835)

    def test_find_largest_directory_recommended_to_delete(self):
        with open("./fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            disk = Disk(input=file_data)
            disk.parse_data()
            self.assertEqual(disk.find_largest_directory_recommended_to_delete(total_disk=70000000, desired_space=30000000), 24933642)
            self.assertEqual(disk.find_largest_directory_recommended_to_delete(total_disk=70000000, desired_space=21700000), 94853)
            self.assertEqual(disk.find_largest_directory_recommended_to_delete(total_disk=70000000, desired_space=20000000), 584)

if __name__ == '__main__':
    unittest.main()
