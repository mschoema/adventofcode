import std/sequtils
import std/strutils

import tables

proc str_replace(s: string, i: int, c: char): string =
  result = s[0..(i-1)] & c & s[(i+1)..^1]

proc tilt_north*(rows: seq[string]): seq[string] =
  var last_empty_slot = newSeqWith(rows[0].len, 0)
  for i, row in rows:
    result.add('.'.repeat(row.len))
    for j, c in row:
      case c
      of '.': discard
      of '#':
        result[i] = str_replace(result[i], j, '#')
        last_empty_slot[j] = i + 1
      of 'O':
        result[last_empty_slot[j]] = str_replace(result[last_empty_slot[j]], j, 'O')
        last_empty_slot[j] += 1
      else: echo "Should not happen"

proc tilt_west(rows: seq[string]): seq[string] =
  for i, row in rows:
    result.add('.'.repeat(row.len))
  var last_empty_slot = newSeqWith(rows.len, 0)
  for j in low(rows[0])..high(rows[0]):
    for i in low(rows)..high(rows):
      let c = rows[i][j]
      case c
      of '.': discard
      of '#':
        result[i] = str_replace(result[i], j, '#')
        last_empty_slot[i] = j + 1
      of 'O':
        result[i] = str_replace(result[i], last_empty_slot[i], 'O')
        last_empty_slot[i] += 1
      else: echo "Should not happen"

proc tilt_south(rows: seq[string]): seq[string] =
  for i, row in rows:
    result.add('.'.repeat(row.len))
  var last_empty_slot = newSeqWith(rows[0].len, high(rows))
  for i in countdown(high(rows), low(rows)):
    let row = rows[i]
    for j, c in row:
      case c
      of '.': discard
      of '#':
        result[i] = str_replace(result[i], j, '#')
        last_empty_slot[j] = i - 1
      of 'O':
        result[last_empty_slot[j]] = str_replace(result[last_empty_slot[j]], j, 'O')
        last_empty_slot[j] -= 1
      else: echo "Should not happen"

proc tilt_east(rows: seq[string]): seq[string] =
  for i, row in rows:
    result.add('.'.repeat(row.len))
  var last_empty_slot = newSeqWith(rows.len, high(rows[0]))
  for j in countdown(high(rows[0]), low(rows[0])):
    for i in low(rows)..high(rows):
      let c = rows[i][j]
      case c
      of '.': discard
      of '#':
        result[i] = str_replace(result[i], j, '#')
        last_empty_slot[i] = j - 1
      of 'O':
        result[i] = str_replace(result[i], last_empty_slot[i], 'O')
        last_empty_slot[i] -= 1
      else: echo "Should not happen"

proc cycle(rows: seq[string]): seq[string] =
  result = tilt_north(rows)
  result = tilt_west(result)
  result = tilt_south(result)
  result = tilt_east(result)

proc count_load*(rows: seq[string]): int =
  for i, row in rows:
    for j, c in row:
      case c
      of 'O': result += rows.len - i
      else: discard

proc main() =
  var rows = readFile("input.txt").split("\n")
  var mem: Table[seq[string], int]
  var curr_i = 0
  var loop_size = 0
  let cycles = 1_000_000_000
  for i in 1..cycles:
    rows = cycle(rows)
    if mem.contains(rows):
      curr_i = i
      loop_size = i - mem[rows]
      break
    else: mem[rows] = i
  let rem = (cycles - curr_i) mod loop_size
  for i in 1..rem:
    rows = cycle(rows)
  let tot = count_load(rows)
  echo tot

when isMainModule:
  main()