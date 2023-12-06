package lib

import (
	"fmt"
	"strconv"
	"strings"
)

type BoatRaceDoc struct {
	Time     []int64
	Distance []int64
}

func ParseDataToBoatRaceDoc(input string) BoatRaceDoc {
	lines := strings.Split(input, "\n")
	return BoatRaceDoc{
		Time:     rowDataParser(lines[0]),
		Distance: rowDataParser(lines[1]),
	}
}

func rowDataParser(input string) []int64 {
	dataParse := strings.Split(strings.TrimSpace(strings.Split(input, ":")[1]), " ")
	result := []int64{}
	for _, datum := range dataParse {
		if datum == "" {
			continue
		}
		parsedDatum, err := strconv.ParseInt(datum, 10, 32)
		if err != nil {
			panic(err)
		}
		result = append(result, parsedDatum)
	}
	return result
}

func (doc BoatRaceDoc) ComputeWaysToWin() int {
	var time, distance int64
	var timeString, distanceString string
	for idx := range doc.Time {
		timeString += fmt.Sprintf("%d", doc.Time[idx])
		distanceString += fmt.Sprintf("%d", doc.Distance[idx])
	}
	time, err := strconv.ParseInt(timeString, 10, 64)
	if err != nil {
		panic(err)
	}
	distance, err = strconv.ParseInt(distanceString, 10, 64)
	if err != nil {
		panic(err)
	}

	return numberOfWaysToWin(time, distance)
}

// number of ways to win
func numberOfWaysToWin(time, distance int64) int {
	wins := 0
	allRaces := computeAllRaces(time)
	for _, race := range allRaces {
		if race > distance {
			wins += 1
		}
	}
	return wins
}

// compute all races
func computeAllRaces(time int64) []int64 {
	races := []int64{}
	// it's inclusive of end of list, as aabsurd as that is
	for i := int64(0); i <= time; i++ {
		races = append(races, i*(time-i))
	}
	return races
}
