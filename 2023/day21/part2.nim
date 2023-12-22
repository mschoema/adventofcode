import std/sets
import std/strutils
import std/tables

import part1

proc main() =
  let garden = readFile("input.txt").split('\n')
  var start: Pos
  for x, l in garden:
    for y, c in l:
      if c == 'S':
        start = [x, y]
        break
  var plots = toHashSet([start])
  var plotDists: Table[Pos, int] = {start: 0}.toTable
  var i = 1
  while true:
    var added = false
    var nextPlots: HashSet[Pos]
    for pos in plots.items:
      for newPos in getNeighbors(garden, pos):
        if not plotDists.hasKey(newPos):
          plotDists[newPos] = i
          added = true
        nextPlots.incl(newPos)
    if not added:
      break
    plots = nextPlots
    i += 1

  # See: https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21
  var even_corners, odd_corners, even_full, odd_full = 0
  for key, val in plotDists.pairs():
    if val mod 2 == 0:
      even_full += 1
      if val > 65:
        even_corners += 1
    else:
      odd_full += 1
      if val > 65:
        odd_corners += 1

  let n = 202300
  echo ((n+1)*(n+1)) * odd_full + (n*n) * even_full - (n+1) * odd_corners + n * even_corners;

when isMainModule:
  main()