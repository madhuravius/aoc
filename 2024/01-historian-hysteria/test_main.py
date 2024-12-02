import unittest
import sys

from main import get_lists_from_data, sum_differences, sum_differences_with_similarity

class TestHistorianHysteria(unittest.TestCase):
    def test_get_lists_from_data(self):
        with open("fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            list_one, list_two, map_of_values_in_two = get_lists_from_data(file_data)
            self.assertEqual(list_one, [3, 4, 2, 1, 3, 3])
            self.assertEqual(list_two, [4, 3, 5, 3, 9, 3])
            self.assertEqual(map_of_values_in_two, {4: 1, 3: 3, 5: 1, 9: 1})

    def test_sum_calibration_values(self):
        with open("fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            list_one, list_two, map_of_values_in_two = get_lists_from_data(file_data)
            self.assertEqual(sum_differences(list_one, list_two), 11)
            self.assertEqual(sum_differences_with_similarity(list_one, list_two, map_of_values_in_two), 31)

if __name__ == '__main__':
    unittest.main()
