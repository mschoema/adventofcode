import std/sets
import std/sequtils
import std/strutils

import fusion/matching

proc getNextDirs*(tile: char, dir: (int, int)): seq[(int, int)] =
  case tile
  of '.': result.add(dir)
  of '-':
    case dir
    of (1, 0), (-1, 0):
      result.add((0, 1))
      result.add((0, -1))
    of (0, 1), (0, -1): result.add(dir)
    else: echo "Should not happen"
  of '|':
    case dir
    of (0, 1), (0, -1):
      result.add((1, 0))
      result.add((-1, 0))
    of (1, 0), (-1, 0): result.add(dir)
    else: echo "Should not happen"
  of '\\':
    case dir
    of (0, 1): result.add((1, 0))
    of (0, -1): result.add((-1, 0))
    of (1, 0): result.add((0, 1))
    of (-1, 0): result.add((0, -1))
    else: echo "Should not happen"
  of '/':
    case dir
    of (0, 1): result.add((-1, 0))
    of (0, -1): result.add((1, 0))
    of (1, 0): result.add((0, -1))
    of (-1, 0): result.add((0, 1))
    else: echo "Should not happen"
  else: echo "Should not happen"

proc countEnergy*(map: seq[string], start: (int, int, (int, int))): int =
  var energymap = newSeqWith(map.len, newSeqWith(map[0].len, false))
  var nextmoves: seq[(int, int, (int, int))]
  var history: HashSet[(int, int, (int, int))]
  nextmoves.add(start)
  while nextmoves.len > 0:
    let (x, y, dir) = nextmoves.pop()
    if containsOrIncl(history, (x, y, dir)):
      continue
    energymap[x][y] = true
    let nextdirs = getNextDirs(map[x][y], dir)
    for nextdir in nextdirs:
      let nextx = x + nextdir[0]
      let nexty = y + nextdir[1]
      if nextx >= low(map) and nextx <= high(map) and
        nexty >= low(map[0]) and nexty <= high(map[0]):
          nextmoves.add((nextx, nexty, nextdir))
  for line in energymap:
    result += line.count(true)

proc main() =
  let map = readFile("input.txt").split('\n')
  echo countEnergy(map, (0, 0, (0, 1)))

when isMainModule:
  main()