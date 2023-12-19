import std/strutils

type
  Dir = enum
    Up, Down, Right, Left

proc parseLine(line: string): (Dir, int) =
  let raw = line.split(' ')
  let n = raw[2][2..^3].parseHexInt
  case raw[2][^2]
  of '3': result = (Up, n)
  of '1': result = (Down, n)
  of '0': result = (Right, n)
  of '2': result = (Left, n)
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