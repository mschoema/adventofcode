import std/heapqueue
import std/strutils
import std/sequtils
import std/tables

import sugar

proc parseIntLine*(line: string): seq[int] =
  line.map(c => ord(c) - ord('0'))

type
  Pos* = (int, int)
  Node* = (Pos, Pos, int)
  QueueElem* = (Node, int)

proc contains*[T](data: seq[seq[T]], pos: Pos): bool =
  result = pos[0] >= low(data) and pos[1] >= low(data[0]) and
    pos[0] <= high(data) and pos[1] <= high(data[0])

proc `[]`*[T](data: seq[seq[T]], pos: Pos): T =
  result = data[pos[0]][pos[1]]

proc `[]`*[T](data: var seq[seq[T]], pos: Pos): var T =
  result = data[pos[0]][pos[1]]

proc `[]=`*[T](data: var seq[seq[T]], pos: Pos, val: T) =
  data[pos[0]][pos[1]] = val

proc `<`*(a, b: QueueElem): bool = a[1] < b[1]

proc `+`*(pos: Pos, dir: Pos): Pos =
  result = (pos[0] + dir[0], pos[1] + dir[1])

proc `-`*(pos: Pos, dir: Pos): Pos =
  result = (pos[0] - dir[0], pos[1] - dir[1])

iterator allDirs*(): Pos =
  yield (0, 1)
  yield (0, -1)
  yield (1, 0)
  yield (-1, 0)

iterator neighbours(n: Node): Node =
  for dir in allDirs():
    if n[1] == dir:
      if n[2] < 2:
        yield (n[0] + dir, dir, n[2] + 1)
    elif n[1] + dir != (0, 0):
      yield (n[0] + dir, dir, 0)

proc main() =
  let data = readFile("input.txt").split('\n').map(parseIntLine)
  let startPos = (low(data), low(data[0]))
  let endPos = (high(data), high(data[0]))
  let startNode1: Node = (startPos, (0, 1), -1)
  let startNode2: Node = (startPos, (1, 0), -1)
  let startDist = 0
  var graph: Table[Node, int]
  graph[startNode1] = startDist
  graph[startNode2] = startDist
  var heap: HeapQueue[QueueElem] = [(startNode1, startDist),
    (startNode2, startDist)].toHeapQueue
  while heap.len > 0:
    let (node, dist) = heap.pop()
    if node[0] == endPos:
      echo dist
      break
    if graph[node] != dist:
      continue
    for newNode in neighbours(node):
      if newNode[0] notin data:
        continue
      else:
        let newDist = dist + data[newNode[0]]
        if not graph.hasKey(newNode) or newDist < graph[newNode]:
            graph[newNode] = newDist
            heap.push((newNode, newDist))

when isMainModule:
  main()