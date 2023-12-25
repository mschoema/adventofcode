import std / [sequtils, strutils]

import sugar

const XMIN = 200000000000000 # 7 for small
const YMIN = 200000000000000 # 7 for small
const XMAX = 400000000000000 # 27 for small
const YMAX = 400000000000000 # 27 for small

type
  Pos3D* = array[3, float]
  Stone* = object
    p*: Pos3D
    d*: Pos3D

proc parseStone*(s: string): Stone =
  let raw = s.split(" @ ")
  let pos = raw[0].split(", ").map(x => x.strip().parseFloat)
  let dir = raw[1].split(", ").map(x => x.strip().parseFloat)
  result = Stone(p: [pos[0], pos[1], pos[2]],
                 d: [dir[0], dir[1], dir[2]])

proc intersect2DIn(a: Stone, b: Stone): bool =
  let discr = b.d[0] * a.d[1] - b.d[1] * a.d[0]
  if discr == 0:
    return false
  else:
    let s = ((a.p[0] - b.p[0]) * a.d[1] - (a.p[1] - b.p[1]) * a.d[0]) / discr
    let t = ((a.p[0] - b.p[0]) * b.d[1] - (a.p[1] - b.p[1]) * b.d[0]) / discr
    if s < 0 or t < 0:
      return false
    else:
      let x = a.p[0] + a.d[0] * t
      let y = a.p[1] + a.d[1] * t
      if x.int64 < XMIN or XMAX < x.int64 or y.int64 < YMIN or YMAX < y.int64:
        return false
      else:
        return true

proc main() =
  var hailstones: seq[Stone]
  for line in lines("input.txt"):
    hailstones.add(line.parseStone())
  var tot = 0
  for i in low(hailstones)..<high(hailstones):
    for j in (i+1)..high(hailstones):
      if intersect2DIn(hailstones[i], hailstones[j]):
        tot += 1
  echo tot

when isMainModule:
  main()