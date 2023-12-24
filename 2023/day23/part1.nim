import std/strutils
import std/sets

type
  Pos* = array[2, int]

proc contains*(data: seq[string], pos: Pos): bool =
  result = pos[0] >= low(data) and pos[1] >= low(data[0]) and
    pos[0] <= high(data) and pos[1] <= high(data[0])

proc `[]`*(data: seq[string], pos: Pos): char =
  result = data[pos[0]][pos[1]]

proc `+`*(pos: Pos, dir: Pos): Pos =
  result = [pos[0] + dir[0], pos[1] + dir[1]]

iterator allDirs*(): Pos =
  yield [0, 1]
  yield [0, -1]
  yield [1, 0]
  yield [-1, 0]

proc getNeighbors(trailmap: seq[string], pos: Pos, path: HashSet[Pos]): seq[Pos] =
  for dir in allDirs():
    let newPos = pos + dir
    if newPos in trailmap and newPos notin path:
      case trailmap[newPos]
      of '.': result.add(newPos)
      of '>':
        if dir == [0, 1]: result.add(newPos)
      of '<':
        if dir == [0, -1]: result.add(newPos)
      of 'v':
        if dir == [1, 0]: result.add(newPos)
      of '^':
        if dir == [-1, 0]: result.add(newPos)
      else: discard

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
  let trailmap = readFile("input.txt").split('\n')
  let startPos = [0, 1]
  let endPos = [140, 139] # [22, 21] for small
  var path: HashSet[Pos]
  echo getLongestPath(trailmap, startPos, path, endPos)

when isMainModule:
  main()