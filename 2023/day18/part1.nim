import std/strutils

type
  Dir = enum
    Up, Down, Right, Left

proc parseLine(line: string): (Dir, int) =
  let raw = line.split(' ')
  let n = raw[1].parseInt
  case raw[0][0]
  of 'U': result = (Up, n)
  of 'D': result = (Down, n)
  of 'R': result = (Right, n)
  of 'L': result = (Left, n)
  else: echo "Should not happen"

proc main() =
  var x, y = 0
  var shoelace, edgelen = 0
  for line in lines("input.txt"):
    let (d, n) = line.parseLine
    edgelen += n
    case d
    of Up: x -= n
    of Down: x += n
    of Right:
      shoelace -= x * n
      y += n
    of Left:
      shoelace += x * n
      y -= n
  echo abs(shoelace) + (edgelen / 2).int + 1

when isMainModule:
  main()