import std/strutils

import part1

proc main() =
  let map = readFile("input.txt").split('\n')
  var maxEnergy = 0
  for x in low(map)..high(map):
    maxEnergy = max(maxEnergy, countEnergy(map, (x, low(map[0]), (0, 1))))
    maxEnergy = max(maxEnergy, countEnergy(map, (x, high(map[0]), (0, -1))))
  for y in low(map[0])..high(map[0]):
    maxEnergy = max(maxEnergy, countEnergy(map, (low(map), y, (1, 0))))
    maxEnergy = max(maxEnergy, countEnergy(map, (high(map), y, (-1, 0))))
  echo maxEnergy

when isMainModule:
  main()