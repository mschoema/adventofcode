import std/sequtils
import std/strutils
import std/threadpool
{.experimental: "parallel".}

import part1

proc main() =
  let map = readFile("input.txt").split('\n')
  var maxEnergy = 0
  var energiesUp = newSeqWith(map.len, 0)
  var energiesDown = newSeqWith(map.len, 0)
  var energiesLeft = newSeqWith(map[0].len, 0)
  var energiesRight = newSeqWith(map[0].len, 0)
  parallel:
    for x in low(map)..high(map):
      energiesUp[x] = spawn countEnergy(map, (x, low(map[0]), (0, 1)))
      energiesDown[x] = spawn countEnergy(map, (x, high(map[0]), (0, -1)))
    for y in low(map[0])..high(map[0]):
      energiesLeft[y] = spawn countEnergy(map, (low(map), y, (1, 0)))
      energiesRight[y] = spawn countEnergy(map, (high(map), y, (-1, 0)))
  echo max([max(energiesUp), max(energiesDown),
    max(energiesLeft), max(energiesRight)])

when isMainModule:
  main()