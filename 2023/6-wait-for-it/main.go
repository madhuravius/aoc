package main

import (
	"log"
	"os"

	"6-wait-for-it/lib"
)

// https://adventofcode.com/2023/day/6
func main() {
	if len(os.Args) < 2 {
		log.Println("No file path provided, call this with: go run ./main.go data.txt")
		panic("No file path provided")
	}

	data, err := os.ReadFile(os.Args[1])
	if err != nil {
		log.Println("Unable to view file provided", err)
		panic(err)
	}
	if data == nil || len(data) == 0 {
		log.Println("File payload is empty, unable to continue")
		panic("Empty file provided, cannot continue")
	}
	parsedData := lib.ParseDataToBoatRaceDoc(string(data))
	log.Printf("Total Product: %d\n", parsedData.ComputeWinProduct())
}
