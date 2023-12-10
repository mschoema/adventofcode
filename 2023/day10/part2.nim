import std/sequtils
import std/strutils

import part1

type
  Tile = enum
    Loop, Inner, Outer
  Side = enum
    Left, Right

proc count_left_turn(curr_dir: Direction, next_pipe: Pipe): int =
  case next_pipe
  of NE:
    case curr_dir
    of South: result = 1
    of West: result = -1
    else: echo "Should not happen 1"
  of NW:
    case curr_dir
    of South: result = -1
    of East: result = 1
    else: echo "Should not happen 2"
  of SW:
    case curr_dir
    of North: result = 1
    of East: result = -1
    else: echo "Should not happen 3"
  of SE:
    case curr_dir
    of North: result = -1
    of WEst: result = 1
    else: echo "Should not happen 4"
  else: result = 0

proc color_inner(tiles: var seq[seq[Tile]], pos: array[2, int],
  pipe: Pipe, dir: Direction, side: Side) =
  case pipe
  of NS:
    case dir
    of North:
      case side
      of Left:
        if pos[1] - 1 >= 0 and tiles[pos[0]][pos[1] - 1] == Outer:
          tiles[pos[0]][pos[1] - 1] = Inner
      of Right:
        if pos[1] + 1 < tiles[0].len and tiles[pos[0]][pos[1] + 1] == Outer:
          tiles[pos[0]][pos[1] + 1] = Inner
    of South:
      case side
      of Right:
        if pos[1] - 1 >= 0 and tiles[pos[0]][pos[1] - 1] == Outer:
          tiles[pos[0]][pos[1] - 1] = Inner
      of Left:
        if pos[1] + 1 < tiles[0].len and tiles[pos[0]][pos[1] + 1] == Outer:
          tiles[pos[0]][pos[1] + 1] = Inner
    else: echo "Should not happen 5"
  of EW:
    case dir
    of East:
      case side
      of Left:
        if pos[0] - 1 >= 0 and tiles[pos[0] - 1][pos[1]] == Outer:
          tiles[pos[0] - 1][pos[1]] = Inner
      of Right:
        if pos[0] + 1 < tiles.len and tiles[pos[0] + 1][pos[1]] == Outer:
          tiles[pos[0] + 1][pos[1]] = Inner
    of West:
      case side
      of Right:
        if pos[0] - 1 >= 0 and tiles[pos[0] - 1][pos[1]] == Outer:
          tiles[pos[0] - 1][pos[1]] = Inner
      of Left:
        if pos[0] + 1 < tiles.len and tiles[pos[0] + 1][pos[1]] == Outer:
          tiles[pos[0] + 1][pos[1]] = Inner
    else: echo "Should not happen 6"
  of NE:
    case dir
    of North:
      case side
      of Left:
        if pos[1] - 1 >= 0 and tiles[pos[0]][pos[1] - 1] == Outer:
          tiles[pos[0]][pos[1] - 1] = Inner
        if pos[0] + 1 < tiles.len and tiles[pos[0] + 1][pos[1]] == Outer:
          tiles[pos[0] + 1][pos[1]] = Inner
      of Right: discard
    of East:
      case side
      of Right:
        if pos[1] - 1 >= 0 and tiles[pos[0]][pos[1] - 1] == Outer:
          tiles[pos[0]][pos[1] - 1] = Inner
        if pos[0] + 1 < tiles.len and tiles[pos[0] + 1][pos[1]] == Outer:
          tiles[pos[0] + 1][pos[1]] = Inner
      of Left: discard
    else: echo "Should not happen 7"
  of NW:
    case dir
    of North:
      case side
      of Left: discard
      of Right:
        if pos[1] + 1 < tiles[0].len and tiles[pos[0]][pos[1] + 1] == Outer:
          tiles[pos[0]][pos[1] + 1] = Inner
        if pos[0] + 1 < tiles.len and tiles[pos[0] + 1][pos[1]] == Outer:
          tiles[pos[0] + 1][pos[1]] = Inner
    of West:
      case side
      of Right: discard
      of Left:
        if pos[1] + 1 < tiles[0].len and tiles[pos[0]][pos[1] + 1] == Outer:
          tiles[pos[0]][pos[1] + 1] = Inner
        if pos[0] + 1 < tiles.len and tiles[pos[0] + 1][pos[1]] == Outer:
          tiles[pos[0] + 1][pos[1]] = Inner
    else: echo "Should not happen 8"
  of SW:
    case dir
    of South:
      case side
      of Left:
        if pos[1] + 1 < tiles[0].len and tiles[pos[0]][pos[1] + 1] == Outer:
          tiles[pos[0]][pos[1] + 1] = Inner
        if pos[0] - 1 >= 0 and tiles[pos[0] - 1][pos[1]] == Outer:
          tiles[pos[0] - 1][pos[1]] = Inner
      of Right: discard
    of West:
      case side
      of Right:
        if pos[1] + 1 < tiles[0].len and tiles[pos[0]][pos[1] + 1] == Outer:
          tiles[pos[0]][pos[1] + 1] = Inner
        if pos[0] - 1 >= 0 and tiles[pos[0] - 1][pos[1]] == Outer:
          tiles[pos[0] - 1][pos[1]] = Inner
      of Left: discard
    else: echo "Should not happen 9"
  of SE:
    case dir
    of East:
      case side
      of Left:
        if pos[1] - 1 >= 0 and tiles[pos[0]][pos[1] - 1] == Outer:
          tiles[pos[0]][pos[1] - 1] = Inner
        if pos[0] - 1 >= 0 and tiles[pos[0] - 1][pos[1]] == Outer:
          tiles[pos[0] - 1][pos[1]] = Inner
      of Right: discard
    of South:
      case side
      of Right:
        if pos[1] - 1 >= 0 and tiles[pos[0]][pos[1] - 1] == Outer:
          tiles[pos[0]][pos[1] - 1] = Inner
        if pos[0] - 1 >= 0 and tiles[pos[0] - 1][pos[1]] == Outer:
          tiles[pos[0] - 1][pos[1]] = Inner
      of Left: discard
    else: echo "Should not happen 10"
  else: echo "Should not happen 11"


proc get_inner_size(map: seq[seq[Pipe]], startPos: (int, int)): int =
  var tiles = newSeqWith(map.len, newSeqWith(map[0].len, Outer))
  var curr_pos: array[2, int] = [startPos[0], startPos[1]]
  var curr_pipe = map[curr_pos[0]][curr_pos[1]]
  var curr_dir = get_start_direction(curr_pipe)
  var count_left = 0
  while true:
    tiles[curr_pos[0]][curr_pos[1]] = Loop
    var next_pos = curr_pos
    case curr_dir
    of North: next_pos[0] -= 1
    of South: next_pos[0] += 1
    of East:  next_pos[1] += 1
    of West:  next_pos[1] -= 1
    let next_pipe = map[next_pos[0]][next_pos[1]]
    count_left += count_left_turn(curr_dir, next_pipe)
    var next_dir: Direction
    discard get_next_direction(curr_dir, next_pipe, next_dir)
    curr_pos = next_pos
    curr_pipe = next_pipe
    curr_dir = next_dir
    if next_pos[0] == startPos[0] and
      next_pos[1] == startPos[1]:
        break
  var side: Side
  if count_left > 0:
    side = Left
  else:
    side = Right
  while true:
    var next_pos = curr_pos
    color_inner(tiles, curr_pos, curr_pipe, curr_dir, side)
    case curr_dir
    of North: next_pos[0] -= 1
    of South: next_pos[0] += 1
    of East:  next_pos[1] += 1
    of West:  next_pos[1] -= 1
    let next_pipe = map[next_pos[0]][next_pos[1]]
    var next_dir: Direction
    discard get_next_direction(curr_dir, next_pipe, next_dir)
    curr_pos = next_pos
    curr_pipe = next_pipe
    curr_dir = next_dir
    if next_pos[0] == startPos[0] and
      next_pos[1] == startPos[1]:
        break
  for i in low(tiles)..(high(tiles) - 1):
    for j in low(tiles[0])..(high(tiles[0]) - 1):
      if tiles[i][j] == Inner:
        if tiles[i][j+1] == Outer:
          tiles[i][j+1] = Inner
        if tiles[i+1][j] == Outer:
          tiles[i+1][j] = Inner
  for i in low(tiles)..high(tiles):
    for j in low(tiles[0])..high(tiles[0]):
      if tiles[i][j] == Inner:
        result += 1

proc main() =
  let input = readFile("input.txt").split("\n")
  var map = newSeqWith(input.len, newSeq[Pipe](input[0].len))
  var startPos: (int, int)
  for i, line in input:
    for j, c in line:
      case c
      of '|': map[i][j] = NS
      of '-': map[i][j] = EW
      of 'L': map[i][j] = NE
      of 'J': map[i][j] = NW
      of '7': map[i][j] = SW
      of 'F': map[i][j] = SE
      of 'S': 
        map[i][j] = Start
        startPos = (i, j)
      else: map[i][j] = Ground
  var max_loop_size = int.low
  var best_pipe: Pipe
  for pipe in NS..SE:
    map[startPos[0]][startPos[1]] = pipe
    let loop_size = get_loop_size(map, startPos)
    if loop_size > max_loop_size:
      max_loop_size = loop_size
      best_pipe = pipe
  map[startPos[0]][startPos[1]] = best_pipe
  echo get_inner_size(map, startPos)

when isMainModule:
  main()