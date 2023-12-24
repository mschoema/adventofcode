import std/strutils
import std/sets

import part1

proc getNeighbors(trailmap: seq[string], pos: Pos, path: HashSet[Pos]): seq[Pos] =
  for dir in allDirs():
    let newPos = pos + dir
    if newPos in trailmap and newPos notin path:
      case trailmap[newPos]
      of '#': discard
      else: result.add(newPos)

proc getLongestPath(trailmap: seq[string], pos: Pos, path: var HashSet[Pos], endPos: Pos): int =
  let neighbors = getNeighbors(trailmap, pos, path)
  if neighbors.len == 0:
    if pos == endPos:
      return 0
    else:
      return -1
  var best = -1
  path.incl(pos)
  for neighbor in neighbors:
    let l = getLongestPath(trailmap, neighbor, path, endPos)
    if l >= 0: best = max(best, l + 1)
  path.excl(pos)
  return best

proc main() =
  let trailmap = readFile("input_small.txt").split('\n')
  let startPos = [0, 1]
  let endPos = [140, 139] # [22, 21] for small
  var path: HashSet[Pos]
  echo getLongestPath(trailmap, startPos, path, endPos)

when isMainModule:
  main()