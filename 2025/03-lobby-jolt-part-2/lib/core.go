package lib

import (
	"fmt"
	"strconv"
	"strings"
)

type BatteryRow []int
type BatteryData []BatteryRow

func ParseDataToBatteries(input string) BatteryData {
	lines := strings.Split(input, "\n")
	data := make(BatteryData, len(lines))
	for lineIdx, line := range lines {
		digits := strings.Split(line, "")
		row := make([]int, len(digits))
		for digitIdx, digit := range digits {
			row[digitIdx], _ = strconv.Atoi(digit)
		}
		data[lineIdx] = row
	}
	return data
}

func (d BatteryData) ComputeTotalJolt() int {
	sum := 0
	for idx, row := range d {
		if len(row) == 0 {
			continue
		}
		fmt.Printf("Processing %d / %d \n", idx+1, len(d))
		sum += row.LargestJoltPossible()
	}
	return sum
}

func (r BatteryRow) LargestJoltPossible() int {
	largestJolt := ""

	largestDigitPos := 0
	for idx := range 12 {
		largestDigitPos = r.FindLargestDigit(largestDigitPos, 12-idx)
		largestJolt += fmt.Sprintf("%d", r[largestDigitPos])

		largestDigitPos += 1
	}

	maxValue, _ := strconv.Atoi(largestJolt)

	return maxValue
}

func (r BatteryRow) FindLargestDigit(minimumLeftPad int, minimumRightPad int) int {
	maxPos := -1
	maxValue := -1

	for pos, digit := range r[minimumLeftPad : len(r)-minimumRightPad+1] {
		if digit > maxValue {
			maxValue = digit
			maxPos = pos + minimumLeftPad
		}
	}

	return maxPos
}
