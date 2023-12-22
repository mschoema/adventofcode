import std/algorithm
import std/sets
import std/sequtils
import std/strutils
import std/tables

import sugar

const XLOW = 0
const XHIGH = 9 # 2 for small
const YLOW = 0
const YHIGH = 9 # 2 for small
const ZLOW = 1
const ZHIGH = 313 # 9 for small

const XLEN = XHIGH - XLOW + 1
const YLEN = YHIGH - YLOW + 1
const ZLEN = ZHIGH - ZLOW + 1

type
  Cube* = array[3, array[2, int]]

template xmin*(c: Cube): int =
  c[0][0]

template xmax*(c: Cube): int =
  c[0][1]

template ymin*(c: Cube): int =
  c[1][0]

template ymax*(c: Cube): int =
  c[1][1]

template zmin*(c: Cube): int =
  c[2][0]

template zmax*(c: Cube): int =
  c[2][1]

proc parseCube*(s: string): Cube =
  let raw = s.split('~').map(x => x.split(',').map(parseInt))
  for i in 0..2:
    result[i][0] = raw[0][i]
    result[i][1] = raw[1][i]

proc bboxExpand(b: var Cube, c: Cube) =
  for i in 0..2:
    b[i][0] = min(b[i][0], c[i][0])
    b[i][1] = max(b[i][1], c[i][1])

proc fillSpace(space: var array[XLEN, array[YLEN, array[ZLOW..ZHIGH, int]]], c: Cube, id: int) =
  for x in c.xmin..c.xmax:
    for y in c.ymin..c.ymax:
      for z in c.zmin..c.zmax:
        space[x][y][z] = id

proc printSpace(space: array[XLEN, array[YLEN, array[ZLOW..ZHIGH, int]]]) =
  for z in ZLOW..ZHIGH:
    echo "Z = ", z
    for x in XLOW..XHIGH:
      var s = ""
      for y in YLOW..YHIGH:
        if space[x][y][z] == 0:
          s = s & '.'
        else:
          s = s & $space[x][y][z]
      echo s

proc main() =
  var cubes: seq[Cube]
  var bbox: Cube = [[0, 0], [0, 0], [1, 1]]
  for line in lines("input.txt"):
    cubes.add(line.parseCube)
    bboxExpand(bbox, cubes[^1])
  cubes.sort((a, b) => cmp(a.zmin, b.zmin))
  # echo bbox # [[0, 2], [0, 2], [1, 9]]
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
    let c = [i].toHashSet
    if not above.hasKey(i):
      tot += 1
      continue
    var canRemove = true
    for a in above[i].items:
      let belowAbove = below[a] - c
      if card(belowAbove) == 0:
        canRemove = false
        break
    if canRemove:
      tot += 1
  echo tot

when isMainModule:
  main()