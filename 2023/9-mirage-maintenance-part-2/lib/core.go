package lib

import (
	"slices"
	"strconv"
	"strings"
)

type CellValues []int

type OasisRow struct {
	Cells CellValues
}

type OasisReport struct {
	Rows         []OasisRow
	ReversedRows []OasisRow
}

func ParseOasisReport(inputData string) OasisReport {
	rows := []OasisRow{}
	reversedRows := []OasisRow{}
	for _, row := range strings.Split(inputData, "\n") {
		cells := []int{}
		for _, cell := range strings.Split(row, " ") {
			parsedCell, err := strconv.ParseInt(cell, 10, 32)
			if err != nil {
				panic(err)
			}
			cells = append(cells, int(parsedCell))
		}
		// only difference is computing backwards because we want to go
		// from end ot start now
		rows = append(rows, OasisRow{
			Cells: cells,
		})
		reversedCells := append([]int{}, cells...)
		slices.Reverse(reversedCells)
		reversedRows = append(reversedRows, OasisRow{
			Cells: reversedCells,
		})
	}
	return OasisReport{
		Rows:         rows,
		ReversedRows: reversedRows,
	}
}

func (o OasisReport) ComputeExtrapolatedValueSum() int {
	sum := 0
	for _, row := range o.Rows {
		sum += row.ComputeExtrapolatedValue()
	}
	return sum
}

func (o OasisReport) ComputeReverseExtrapolatedValueSum() int {
	sum := 0
	for _, row := range o.ReversedRows {
		sum += row.ComputeExtrapolatedValue()
	}
	return sum
}

func (o OasisRow) ComputeExtrapolatedValue() int {
	// for each row, compute deltas and keep deltaing until no zeroes remain
	deltas := o.ComputeExtrapolatedDeltas()
	sum := 0

	for i := len(deltas) - 1; i > 0; i-- {
		lastDeltaRowIdx := len(deltas[i]) - 1
		sum += deltas[i][lastDeltaRowIdx]
	}

	return o.Cells[len(o.Cells)-1] + sum
}

func (o OasisRow) ComputeExtrapolatedDeltas() []CellValues {
	extrapolatedCells := []CellValues{o.Cells}
	for !extrapolatedCells[len(extrapolatedCells)-1].IsComplete() {
		rowToAddForExtrapolation := []int{}
		for idx, cell := range extrapolatedCells[len(extrapolatedCells)-1] {
			if idx == 0 {
				continue
			}
			deltaToSave := cell - extrapolatedCells[len(extrapolatedCells)-1][idx-1]
			rowToAddForExtrapolation = append(rowToAddForExtrapolation, deltaToSave)
		}
		extrapolatedCells = append(extrapolatedCells, rowToAddForExtrapolation)
	}
	return extrapolatedCells
}

func (c CellValues) IsComplete() bool {
	for _, val := range c {
		if val != 0 {
			return false
		}
	}
	return true
}
