import std/math
import std/strutils
import std/tables


proc get_next_z(map: Table[string, (string, string)], 
  moves: string, start_node: string): int =
  result = 0
  var node = start_node
  while not node.endsWith('Z') or result == 0:
    case moves[result mod moves.len]
    of 'L': node = map[node][0]
    of 'R': node = map[node][1]
    else: echo "Problem"
    result += 1


proc main() =
  var map: Table[string, (string, string)]
  var nodes: seq[string]
  for line in lines("input/network.txt"):
    var newline = line.replace(")", "")
    var input = newline.split(" = (")
    var output = input[1].split(", ")
    map[input[0]] = (output[0], output[1])
    if input[0].endsWith('A'):
      nodes.add(input[0])
  let moves = readFile("input/moves.txt")
  var cicles: seq[int]
  for i, node in nodes:
    cicles.add(get_next_z(map, moves, node))
  echo lcm(cicles)
  

when isMainModule:
  main()