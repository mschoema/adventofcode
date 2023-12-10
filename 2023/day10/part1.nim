import std/sequtils
import std/strutils

type
  Direction* = enum
    North, South, East, West
  Pipe* = enum
    NS, EW, NE, NW, SW, SE, Ground, Start

proc get_start_direction*(pipe: Pipe): Direction =
  case pipe
  of NS, NW: result = North
  of EW, NE: result = East
  of SW, SE: result = South
  else: echo "Should not happen"

proc get_next_direction*(curr_direction: Direction, 
  next_pipe: Pipe, next_direction: var Direction): bool =
  result = true
  case next_pipe
  of NS:
    case curr_direction
    of North: next_direction = North
    of South: next_direction = South
    else: result = false
  of EW:
    case curr_direction
    of West: next_direction = West
    of East: next_direction = East
    else: result = false
  of NE:
    case curr_direction
    of South: next_direction = East
    of West: next_direction = North
    else: result = false
  of NW:
    case curr_direction
    of South: next_direction = West
    of East: next_direction = North
    else: result = false
  of SW:
    case curr_direction
    of East: next_direction = South
    of North: next_direction = West
    else: result = false
  of SE:
    case curr_direction
    of West: next_direction = South
    of North: next_direction = East
    else: result = false
  else: result = false


proc get_loop_size*(map: seq[seq[Pipe]], startPos: (int, int)): int =
  var curr_pos: array[2, int] = [startPos[0], startPos[1]]
  var curr_pipe = map[curr_pos[0]][curr_pos[1]]
  var curr_dir = get_start_direction(curr_pipe)
  result = 0
  while true:
    var next_pos = curr_pos
    case curr_dir
    of North: next_pos[0] -= 1
    of South: next_pos[0] += 1
    of East:  next_pos[1] += 1
    of West:  next_pos[1] -= 1
    if next_pos[0] < 0 or 
      next_pos[0] == map.len or
      next_pos[1] < 0 or
      next_pos[1] == map[0].len:
        result = -1
        break
    let next_pipe = map[next_pos[0]][next_pos[1]]
    var next_dir: Direction
    if get_next_direction(curr_dir, next_pipe, next_dir):
      curr_pos = next_pos
      curr_pipe = next_pipe
      curr_dir = next_dir
      result += 1
      if next_pos[0] == startPos[0] and
        next_pos[1] == startPos[1]:
          break
    else:
      result = -1
      break

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
  for pipe in NS..SE:
    map[startPos[0]][startPos[1]] = pipe
    let loop_size = get_loop_size(map, startPos)
    if loop_size > max_loop_size:
      max_loop_size = loop_size
  echo (max_loop_size / 2).int

when isMainModule:
  main()