package lib

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseDataToBoatRaceDoc(t *testing.T) {
	parsedInput := ParseDataToBoatRaceDoc(`Time:      7  15   30
Distance:  9  40  200`)
	assert.Equal(t, parsedInput, BoatRaceDoc{
		Time:     []int64{7, 15, 30},
		Distance: []int64{9, 40, 200},
	})
}

func TestComputeAllRaces(t *testing.T) {
	parsedInput := ParseDataToBoatRaceDoc(`Time:      7  15   30
Distance:  9  40  200`)
	assert.Equal(t, computeAllRaces(parsedInput.Time[0]), []int64{0, 6, 10, 12, 12, 10, 6, 0})
}

func TestNumberOfWaysToWin(t *testing.T) {
	parsedInput := ParseDataToBoatRaceDoc(`Time:      7  15   30
Distance:  9  40  200`)
	assert.Equal(t, numberOfWaysToWin(parsedInput.Time[0], parsedInput.Distance[0]), 4)
}

func TestNumberOfWaysToWinForAllTimesAndDistances(t *testing.T) {
	parsedInput := ParseDataToBoatRaceDoc(`Time:      7  15   30
Distance:  9  40  200`)
	assert.Equal(t, parsedInput.ComputeWinProduct(), 288)
}
