import sugar
include std/strutils
include std/sequtils

proc get_next_series(series: seq[int]): seq[int] = 
  for i in low(series)..(high(series) - 1):
    result.add(series[i+1] - series[i])

proc get_next_prev_value(line: string): (int, int) = 
  var series: seq[seq[int]]
  series.add(line.splitWhitespace().map(parseInt))
  while not all(series[^1], (v) => v == 0):
    series.add(get_next_series(series[^1]))
  var next_value = 0
  for i in countdown(high(series), low(series)):
    next_value += series[i][^1]
  var prev_value = 0
  for i in countdown(high(series), low(series)):
    prev_value = series[i][0] - prev_value
  return (next_value, prev_value)

proc main() =
  var tot_next = 0
  var tot_prev = 0
  for line in lines("input.txt"):
    let (next, prev) = get_next_prev_value(line)
    tot_next += next
    tot_prev += prev
  echo "Part1 = ", tot_next
  echo "Part2 = ", tot_prev


when isMainModule:
  main()