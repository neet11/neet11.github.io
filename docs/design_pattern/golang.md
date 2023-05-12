# Golang

## go example

```go
package main

import (
    "fmt"
    "sort"
)

type NumCount struct {
    Num   int
    Count int
}

func countNums(nums []int) map[int]int {
    counts := make(map[int]int)
    for _, num := range nums {
        counts[num]++
    }
    return counts
}

func sortNumCounts(counts map[int]int) []NumCount {
    var numCounts []NumCount
    for num, count := range counts {
        numCounts = append(numCounts, NumCount{num, count})
    }
    sort.Slice(numCounts, func(i, j int) bool {
        return numCounts[i].Count > numCounts[j].Count
    })
    return numCounts
}

func main() {
    nums := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5}
    counts := countNums(nums)
    numCounts := sortNumCounts(counts)
    for _, nc := range numCounts {
        fmt.Printf("%d 出现了 %d 次\n", nc.Num, nc.Count)
    }
}
```
