package day5

import (
    "testing"
)

func assertEqual(t *testing.T, a interface{}, b interface{}) {
	if a != b {
		t.Fatalf("%v != %v", a, b)
	}
}

func TestRangeMapConv(t *testing.T) {
	var rangeMap RangeMap = []Range{
		Range {
			destStart:     50,
			sourceStart:   98,
			length:        2,
		},
		Range {
			destStart:     52,
			sourceStart:   50,
			length:        48,
		},
	}
	assertEqual(t, rangeMap.Conv(98), 50)
	assertEqual(t, rangeMap.Conv(99), 51)
	assertEqual(t, rangeMap.Conv(100), 100)
}
