import unittest

from main import RedNoseReport

class TestHistorianHysteria(unittest.TestCase):
    def test_get_safe_reports(self):
        with open("fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            reports = RedNoseReport(file_data)
            self.assertEqual(reports.get_safe_reports(), 2)


if __name__ == '__main__':
    unittest.main()
