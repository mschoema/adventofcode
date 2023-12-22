import std/algorithm
import std/sets
import std/tables

import sugar

import part1

const XLOW = 0
const XHIGH = 9 # 2 for small
const YLOW = 0
const YHIGH = 9 # 2 for small
const ZLOW = 1
const ZHIGH = 313 # 9 for small

const XLEN = XHIGH - XLOW + 1
const YLEN = YHIGH - YLOW + 1
const ZLEN = ZHIGH - ZLOW + 1

proc fillSpace*(space: var array[XLEN, array[YLEN, array[ZLOW..ZHIGH, int]]], c: Cube, id: int) =
  for x in c.xmin..c.xmax:
    for y in c.ymin..c.ymax:
      for z in c.zmin..c.zmax:
        space[x][y][z] = id

proc main() =
  var cubes: seq[Cube]
  for line in lines("input.txt"):
    cubes.add(line.parseCube)
  cubes.sort((a, b) => cmp(a.zmin, b.zmin))
  var space: array[XLEN, array[YLEN, array[ZLOW..ZHIGH, int]]]
  var below: Table[int, HashSet[int]]
  var above: Table[int, HashSet[int]]
  for i in 1..cubes.len:
    let c = cubes[i - 1]
    var belowC: HashSet[int]
    for z in countdown(c.zmin - 1, 1):
      for x in c.xmin..c.xmax:
        for y in c.ymin..c.ymax:
          if space[x][y][z] != 0:
            belowC.incl(space[x][y][z])
      if card(belowC) == 0:
        cubes[i - 1].zmin -= 1
        cubes[i - 1].zmax -= 1
      else:
        break
    fillSpace(space, cubes[i - 1], i)
    below[i] = belowC
    above[i] = initHashSet[int]()
    for j in belowC.items:
      above[j].incl(i)

  var tot = 0
  for i in 1..cubes.len:
    var removed: HashSet[int] = [i].toHashSet
    var currentAbove = above[i]
    while card(currentAbove) > 0:
      var nextAbove: HashSet[int]
      for a in currentAbove.items:
        let aBelow = below[a] - removed
        if card(aBelow) == 0:
          removed.incl(a)
          nextAbove = nextAbove.union(above[a])
      currentAbove = nextAbove
    tot += card(removed) - 1
  echo tot

when isMainModule:
  main()