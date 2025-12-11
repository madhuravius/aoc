package lib_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"jolt/lib"
)

func TestParseDataToBoatRaceDoc(t *testing.T) {
	parsedInput := lib.ParseDataToBatteries(`987654321111111
811111111111119`)
	assert.Equal(t, parsedInput, lib.BatteryData{
		[]int{9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1},
		[]int{8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9},
	})
}

func TestLargestJoltPossible(t *testing.T) {
	data := lib.BatteryRow{9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1}
	assert.Equal(t, 98, data.LargestJoltPossible())
}

func TestComputeTotalJolt(t *testing.T) {
	parsedInput := lib.ParseDataToBatteries(`987654321111111
811111111111119
234234234234278
818181911112111`)
	assert.Equal(t, parsedInput.ComputeTotalJolt(), 357)
}
