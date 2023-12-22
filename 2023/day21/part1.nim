import std/sets
import std/strutils

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

iterator getNeighbors*(garden: seq[string], pos: Pos): Pos =
  for dir in allDirs():
    let newPos = pos + dir
    if newPos in garden:
      case garden[newPos]
      of '.', 'S': yield newPos
      else: discard

proc strReplace*(s: string, i: int, c: char): string =
  result = s[0..(i-1)] & c & s[(i+1)..^1]

proc printGarden(garden: seq[string], plots: HashSet[Pos]) =
  var newGarden = garden
  for pos in plots:
    newGarden[pos[0]] = strReplace(newGarden[pos[0]], pos[1], 'O')
  for line in newGarden:
    echo line

proc main() =
  let garden = readFile("input.txt").split('\n')
  var start: Pos
  for x, l in garden:
    for y, c in l:
      if c == 'S':
        start = [x, y]
        break
  var plots = toHashSet([start])
  for i in 1..64:
    var nextPlots: HashSet[Pos]
    for pos in plots.items:
      for newPos in getNeighbors(garden, pos):
        nextPlots.incl(newPos)
    plots = nextPlots
  echo plots.len

when isMainModule:
  main()