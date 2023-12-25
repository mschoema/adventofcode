import std/sequtils

import neo

import part1

const EPSILON = 1e-3

proc getJacobian(s: Stone, t: Pos3D, a, b, c: Stone): auto =
  let dxs = s.d[0]
  let dys = s.d[1]
  let dzs = s.d[2]
  result = matrix(@[
    @[1.0, 0, 0, t[0], 0, 0, dxs + a.d[0], 0, 0],
    @[0, 1, 0, 0, t[0], 0, dys + a.d[1], 0, 0],
    @[0, 0, 1, 0, 0, t[0], dzs + a.d[2], 0, 0],
    @[1, 0, 0, t[1], 0, 0, 0, dxs + b.d[0], 0],
    @[0, 1, 0, 0, t[1], 0, 0, dys + b.d[1], 0],
    @[0, 0, 1, 0, 0, t[1], 0, dzs + b.d[2], 0],
    @[1, 0, 0, t[2], 0, 0, 0, 0, dxs + c.d[0]],
    @[0, 1, 0, 0, t[2], 0, 0, 0, dys + c.d[1]],
    @[0, 0, 1, 0, 0, t[2], 0, 0, dzs + c.d[2]]
  ])

proc getNegFunct(s: Stone, t: Pos3D, a, b, c: Stone): auto  =
  let (ta, tb, tc) = (t[0], t[1], t[2])
  let (xs, xa, xb, xc) = (s.p[0], a.p[0], b.p[0], c.p[0])
  let (ys, ya, yb, yc) = (s.p[1], a.p[1], b.p[1], c.p[1])
  let (zs, za, zb, zc) = (s.p[2], a.p[2], b.p[2], c.p[2])
  let (dxs, dxa, dxb, dxc) = (s.d[0], a.d[0], b.d[0], c.d[0])
  let (dys, dya, dyb, dyc) = (s.d[1], a.d[1], b.d[1], c.d[1])
  let (dzs, dza, dzb, dzc) = (s.d[2], a.d[2], b.d[2], c.d[2])
  result = -1.0 * vector(@[
    xs + ta * (dxs + dxa) + xa,
    ys + ta * (dys + dya) + ya,
    zs + ta * (dzs + dza) + za,
    xs + tb * (dxs + dxb) + xb,
    ys + tb * (dys + dyb) + yb,
    zs + tb * (dzs + dzb) + zb,
    xs + tc * (dxs + dxc) + xc,
    ys + tc * (dys + dyc) + yc,
    zs + tc * (dzs + dzc) + zc
  ])

proc main() =
  var hailstones: seq[Stone]
  for line in lines("input.txt"):
    hailstones.add(line.parseStone())
  let a = hailstones[0]
  let b = hailstones[1]
  let c = hailstones[2]
  var s = hailstones[3]
  var t: Pos3D = [20, 30, 40]
  while true:
    let J = getJacobian(s, t, a, b, c)
    let F = getNegFunct(s, t, a, b, c)
    let D = solve(J, F)
    if l_1(D) < EPSILON:
      break
    s.p[0] += D[0]
    s.p[1] += D[1]
    s.p[2] += D[2]
    s.d[0] += D[3]
    s.d[1] += D[4]
    s.d[2] += D[5]
    t[0] += D[6]
    t[1] += D[7]
    t[2] += D[8]

  # Not sure why we need a (-1 * ...), but this works
  # Must have had a sign error somewhere above
  echo -1 * sum(vector(s.p.map(toInt)))

when isMainModule:
  main()