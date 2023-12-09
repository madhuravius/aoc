import unittest

from main import calibration_value, sum_calibration_values

class TestTrebuchetCode(unittest.TestCase):
    def test_calibration_value(self):
        self.assertEqual(calibration_value('1abc2'), 12)
        self.assertEqual(calibration_value('pqr3stu8vwx'), 38)
        self.assertEqual(calibration_value('a1b2c3d4e5f'), 15)
        self.assertEqual(calibration_value('treb7uchet'), 77)

    def test_sum_calibration_values(self):
        self.assertEqual(sum_calibration_values("\n".join(["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"])), 142)

if __name__ == '__main__':
    unittest.main()
