import unittest

from main import calibration_value, sum_calibration_values

class TestTrebuchetCode(unittest.TestCase):
    def test_calibration_value(self):
        """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen

        In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
        """
        self.assertEqual(calibration_value('two1nine'), 29)
        self.assertEqual(calibration_value('eightwothree'), 83)
        self.assertEqual(calibration_value('abcone2threexyz'), 13)
        self.assertEqual(calibration_value('xtwone3four'), 24)
        self.assertEqual(calibration_value('4nineeightseven2'),42)
        self.assertEqual(calibration_value('zoneight234'), 14)
        self.assertEqual(calibration_value('7pqrstsixteen'), 76)

    def test_sum_calibration_values(self):
        """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen

        Adding these together produces 281.
        """
        self.assertEqual(sum_calibration_values("\n".join(["two1nine", "eightwothree", "abcone2threexyz", "xtwone3four", "4nineeightseven2", "zoneight234", "7pqrstsixteen"])), 281)

if __name__ == '__main__':
    unittest.main()
