package main

import "slices"

func main() {
	numbers := []int{1, 2, 3, 4, 5}
	slices.Reverse(numbers)
	numbers[len(numbers)-1]
}
