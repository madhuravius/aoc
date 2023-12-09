package lib

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseOasisReport(t *testing.T) {
	parsedInput := ParseOasisReport(`0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`)
	assert.Equal(t, parsedInput, OasisReport{
		Rows: []OasisRow{
			{
				Cells: []int{0, 3, 6, 9, 12, 15},
			},
			{
				Cells: []int{1, 3, 6, 10, 15, 21},
			},
			{
				Cells: []int{10, 13, 16, 21, 30, 45},
			},
		},
		ReversedRows: []OasisRow{
			{
				Cells: []int{15, 12, 9, 6, 3, 0},
			},
			{
				Cells: []int{21, 15, 10, 6, 3, 1},
			},
			{
				Cells: []int{45, 30, 21, 16, 13, 10},
			},
		},
	})
}


func TestComputeExtrapolatedDeltas(t *testing.T) {

	row := OasisRow{
		Cells: []int{0, 3, 6, 9, 12, 15},
	}
	assert.Equal(t, row.ComputeExtrapolatedDeltas(), []CellValues{
		{0, 3, 6, 9, 12, 15},
		{3, 3, 3, 3, 3},
		{0, 0, 0, 0},
	})
}

func TestComputeExtrapolatedDeltasVariant(t *testing.T) {

	row := OasisRow{
		Cells: []int{15, 12, 9, 6, 3, 0},
	}
	assert.Equal(t, row.ComputeExtrapolatedDeltas(), []CellValues{
		{15, 12, 9, 6, 3, 0},
		{-3, -3, -3, -3, -3},
		{0, 0, 0, 0},
	})
}

func TestComputeExtrapolatedValueForRow(t *testing.T) {
	assert.Equal(t, OasisRow{
		Cells: []int{0, -3, -6, -9, -12, -15},
	}.ComputeExtrapolatedValue(), -18)
	assert.Equal(t, OasisRow{
		Cells: []int{0, 3, 6, 9, 12, 15},
	}.ComputeExtrapolatedValue(), 18)
	assert.Equal(t, OasisRow{
		Cells: []int{1, 3, 6, 10, 15, 21},
	}.ComputeExtrapolatedValue(), 28)
	assert.Equal(t, OasisRow{
		Cells: []int{10, 13, 16, 21, 30, 45},
	}.ComputeExtrapolatedValue(), 68)
}

func TestComputeExtrapolatedValueForRowVariant(t *testing.T) {
	assert.Equal(t, OasisRow{
		Cells: []int{-15, -12, -9, -6, -3, 0},
	}.ComputeExtrapolatedValue(), 3)
	assert.Equal(t, OasisRow{
		Cells: []int{15, 12, 9, 6, 3, 0},
	}.ComputeExtrapolatedValue(), -3)
	assert.Equal(t, OasisRow{
		Cells: []int{21, 15, 10, 6, 3, 1},
	}.ComputeExtrapolatedValue(), 0)
	assert.Equal(t, OasisRow{
		Cells: []int{45, 30, 21, 16, 13, 10},
	}.ComputeExtrapolatedValue(), 5)
}

func TestComputeExtrapolatedValueForReport(t *testing.T) {
	parsedInput := ParseOasisReport(`0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`)
	assert.Equal(t, parsedInput.ComputeExtrapolatedValueSum(), 114)
	assert.Equal(t, parsedInput.ComputeReverseExtrapolatedValueSum(), 2)
}
