package day5

import (
	"bufio"
	_ "fmt"
	_ "io"
	"log"
	"os"
	"strings"
	"strconv"
)

type Range struct {
	destStart   int
	sourceStart int
	length      int
}

type RangeMap []Range

func (rangeMap *RangeMap) Conv(value int) int {
	for _, r := range *rangeMap {
		if r.sourceStart <= value && value < r.sourceStart + r.length {
			return r.destStart + (value - r.sourceStart)
		}
	}
	return value
}

func readRangeMap(scanner *bufio.Scanner) RangeMap {
	// seed to soil map
	var rangeMap RangeMap

	scanner.Scan()
	_ = scanner.Text()

	for {
		scanner.Scan();
		rangeLine := scanner.Text()
		if (rangeLine == "") {
			break;
		}
		ranges := strings.SplitN(rangeLine, " ", 3)
		destStart, _   := strconv.Atoi(ranges[0])
		sourceStart, _ := strconv.Atoi(ranges[1])
		length, _      := strconv.Atoi(ranges[2])

		// fmt.Println(ranges)

		rangeMap = append(rangeMap, Range{
			destStart:   destStart,
			sourceStart: sourceStart,
			length:      length,
		})
	}
	return rangeMap
}

func SolA() int {
	
	file, err := os.Open("input/day5.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)

	scanner.Scan()
	seedsStr := scanner.Text()
	seedsStr = strings.TrimPrefix(seedsStr, "seeds: ")
	var seeds []int
	for _, seed := range strings.Split(seedsStr, " ") {
		parsedSeed, _ := strconv.Atoi(seed)
		seeds = append(seeds, parsedSeed)
	}

	// new line
	scanner.Scan()
	_ = scanner.Text()

	var rangeMaps []RangeMap
	for i := 0; i < 7; i++ {
		rangeMaps = append(rangeMaps, readRangeMap(scanner))
	}

	ans := ^uint(0)
	for _, seed := range seeds {
		location := seed
		for _, rangeMap := range rangeMaps {
			location = rangeMap.Conv(location)
		}
		if uint(location) < ans {
			ans = uint(location)
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	return int(ans)
}
