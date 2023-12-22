package day5

import (
	"bufio"
	"fmt"
	_ "fmt"
	_ "io"
	"log"
	"os"
	"strings"
	"strconv"
)

type Range struct {
	sourceStart int
	destStart   int
	length      int
}

type RangeMap []Range

func SolA() {
	
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
	seeds := strings.Split(seedsStr, " ")
	_ = seeds

	// new line
	scanner.Scan()
	_ = scanner.Text()

	// seed to soil map
	var seedToSoil RangeMap

	scanner.Scan()
	_ = scanner.Text()

	for {
		scanner.Scan();
		rangeLine := scanner.Text()
		if (rangeLine == "") {
			break;
		}
		ranges := strings.SplitN(rangeLine, " ", 3)
		sourceStart, _ := strconv.Atoi(ranges[0])
		destStart, _   := strconv.Atoi(ranges[1])
		length, _      := strconv.Atoi(ranges[2])

		fmt.Println(ranges)

		seedToSoil = append(seedToSoil, Range{
			sourceStart: sourceStart,
			destStart:   destStart,
			length:      length,
		})
	}



	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}


}
