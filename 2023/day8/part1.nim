import std/strutils
import std/tables


proc main() =
  var map: Table[string, (string, string)]
  for line in lines("network.txt"):
    var newline = line.replace(")", "")
    var input = newline.split(" = (")
    var output = input[1].split(", ")
    map[input[0]] = (output[0], output[1])
  let moves = readFile("moves.txt")
  var loc = "AAA"
  var i = 0
  while loc != "ZZZ":
    case moves[i mod moves.len]
    of 'L': loc = map[loc][0]
    of 'R': loc = map[loc][1]
    else: echo "Problem"
    i += 1
  echo i




when isMainModule:
  main()