import std/heapqueue
import std/strutils
import std/sequtils
import std/tables

import part1

iterator neighbours(n: Node): Node =
  for dir in allDirs():
    if n[1] == dir:
      if n[2] < 9:
        yield (n[0] + dir, dir, n[2] + 1)
    elif n[1] + dir != (0, 0):
      if n[2] >= 3:
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
      if node[2] < 3:
        continue
      else:
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