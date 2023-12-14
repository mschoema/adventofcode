import std/sequtils
import std/strutils

proc main() =
  var rows = readFile("input.txt").split("\n")
  var curr_vals = newSeqWith(rows[0].len, rows.len)
  var tot = 0
  for i, row in rows:
    for j, c in row:
      case c
      of '.': discard
      of '#': curr_vals[j] = rows.len - i - 1
      of 'O': 
        tot += curr_vals[j]
        dec curr_vals[j]
      else: echo "Should not happen"
  echo tot

when isMainModule:
  main()