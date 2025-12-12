package main

import (
	"log"
	"os"

	"jolt/lib"
)

// https://adventofcode.com/2025/day/3
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
	if len(data) == 0 {
		log.Println("File payload is empty, unable to continue")
		panic("Empty file provided, cannot continue")
	}
	parsedData := lib.ParseDataToBatteries(string(data))
	log.Printf("Total Jolt: %d\n", parsedData.ComputeTotalJolt())
}
