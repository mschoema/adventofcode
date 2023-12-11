import sugar
import std/algorithm
import std/strutils

type
  Star = tuple
    x, y: int

proc main(n: int) = 
  let img = readFile("input.txt").split("\n")
  var stars: seq[Star]
  for i, line in img:
    for j, c in line:
      if c == '#':
        stars.add((i, j))
  block:
    stars.sort((l, r) => cmp(l.x, r.x))
    var addX = 0
    for i in low(stars)..(high(stars)-1):
      let nextAddX = max(0, (stars[i+1].x - stars[i].x - 1) * (n - 1))
      stars[i].x += addX
      addX += nextAddX
    stars[^1].x += addX
  block:
    stars.sort((l, r) => cmp(l.y, r.y))
    var addY = 0
    for i in low(stars)..(high(stars)-1):
      let nextAddY = max(0, (stars[i+1].y - stars[i].y - 1) * (n - 1))
      stars[i].y += addY
      addY += nextAddY
    stars[^1].y += addY
  var tot = 0
  for i in low(stars)..(high(stars)-1):
    for j in (i+1)..high(stars):
      tot += abs(stars[i].x - stars[j].x) +
        abs(stars[i].y - stars[j].y)
  echo tot


when isMainModule:
  echo "---Part 1---"
  main(2)
  echo "---Part 2---"
  main(1000000)