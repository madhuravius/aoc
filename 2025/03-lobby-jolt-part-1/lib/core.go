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
	for _, row := range d {
		sum += row.LargestJoltPossible()
	}
	return sum
}

func (r BatteryRow) LargestJoltPossible() int {
	// given item, everything to the right, max
	// keep going until complete
	maxValue := 0
	for tensPosition, tensValue := range r {
		for _, onesValue := range r[tensPosition + 1:] {
			strValue := fmt.Sprintf("%d%d", tensValue, onesValue)
			num, _ := strconv.Atoi(strValue)
			if num > maxValue {
				maxValue = num
			}
		}
	}
	return maxValue
}
