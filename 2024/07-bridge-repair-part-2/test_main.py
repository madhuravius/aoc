import unittest

from main import determine_if_inputs_and_outputs_can_be_made_equal, get_inputs_and_outputs, inputs_and_outputs_can_be_made_equal

class TestHistorianHysteria(unittest.TestCase):
    def test_get_lists_from_data(self):
        with open("fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            inputs_and_outputs = get_inputs_and_outputs(file_data)
            self.assertEqual(inputs_and_outputs[0], (190, [10, 19]))
    def test_inputs_and_outputs_can_be_made_equal(self):
        with open("fixtures/test_input.txt") as f:
            file_data = str(f.read()).strip()
            inputs_and_outputs = get_inputs_and_outputs(file_data)
            self.assertEqual(inputs_and_outputs_can_be_made_equal(inputs_and_outputs), 11387)

if __name__ == '__main__':
    unittest.main()
