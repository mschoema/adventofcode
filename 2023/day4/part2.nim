import std/math
import std/sequtils
import std/strutils

from part1 import get_card_points

proc main() =
  var tot = 0
  let lines = readFile("input.txt").splitLines()
  var copies = repeat(1, len(lines))
  for i, line in lines:
    var points = get_card_points(line)
    for j in i + 1 .. min(i + points, high(lines)):
      copies[j] += copies[i]
  echo sum(copies)

when isMainModule:
  main()