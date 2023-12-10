import unittest

from main import Submarine

class TestSubmarineCode(unittest.TestCase):
    def test_calibration_value(self):
        self.assertEqual(Submarine("""forward 5
down 5
forward 8
up 3
down 8
forward 2""").generate_product(), 900)


if __name__ == '__main__':
    unittest.main()
