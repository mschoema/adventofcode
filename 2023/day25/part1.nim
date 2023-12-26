import std/sequtils
import std/strutils
import std/tables
import std/random

# Call 'randomize()' for random seed
# With default seed, the solution is
# found in 20 iteration 

# randomize()

type
  Graph = object
    maxId: int
    numVertices: int
    numEdges: int
    vertexMap: Table[string, int]
    edgeMap: Table[int, seq[int]]
    vertexSize: Table[int, int]

proc addVertex(graph: var Graph, vertex: string) =
  if not graph.vertexMap.hasKey(vertex):
    graph.vertexMap[vertex] = graph.maxId
    graph.vertexSize[graph.maxId] = 1
    graph.edgeMap[graph.maxId] = @[]
    inc graph.numVertices
    inc graph.maxId

proc addAnonVertex(graph: var Graph, size: int): int =
  graph.vertexSize[graph.maxId] = size
  graph.edgeMap[graph.maxId] = @[]
  result = graph.maxId
  inc graph.numVertices
  inc graph.maxId

proc getVertexId(graph: var Graph, vertex: string): int =
  if not graph.vertexMap.hasKey(vertex):
    graph.addVertex(vertex)
  result = graph.vertexMap[vertex]

proc addConnection(graph: var Graph, v1, v2: string) =
  let id1 = graph.getVertexId(v1)
  let id2 = graph.getVertexId(v2)
  if id2 notin graph.edgeMap[id1]:
    graph.edgeMap[id1].add(id2)
    graph.edgeMap[id2].add(id1)
    inc graph.numEdges

proc contractEdge(graph: var Graph, vId1, vId2: int) =
  let vSize = graph.vertexSize[vId1] + graph.vertexSize[vId2]
  let vId = graph.addAnonVertex(vSize)
  var v1v2Edges: int = 0
  for neighbor in graph.edgeMap[vId1]:
    if neighbor != vId2:
      for i in low(graph.edgeMap[neighbor])..high(graph.edgeMap[neighbor]):
        if graph.edgeMap[neighbor][i] == vId1:
          graph.edgeMap[neighbor][i] = vId
          graph.edgeMap[vId].add(neighbor)
    else:
      inc v1v2Edges
  for neighbor in graph.edgeMap[vId2]:
    if neighbor != vId1:
      for i in low(graph.edgeMap[neighbor])..high(graph.edgeMap[neighbor]):
        if graph.edgeMap[neighbor][i] == vId2:
          graph.edgeMap[neighbor][i] = vId
          graph.edgeMap[vId].add(neighbor)
  graph.edgeMap.del(vId1)
  graph.edgeMap.del(vId2)
  dec graph.numEdges, v1v2Edges
  dec graph.numVertices, 2

proc getMinCut(graph: var Graph): (int, seq[int]) =  
  while graph.numVertices > 2:
    var e = rand((graph.numEdges * 2 - 1).int)
    for key, val in graph.edgeMap.pairs():
      if val.len <= e:
        dec e, val.len
      else:
        let v1 = key
        let v2 = val[e]
        graph.contractEdge(v1, v2)
        break
  var sizes: seq[int]
  var n: int
  for key, val in graph.edgeMap.pairs():
    n = val.len.int
    sizes.add(graph.vertexSize[key])
  result = (n, sizes)

proc main() =
  var graph: Graph
  for line in lines("input.txt"):
    let raw = line.split(": ")
    let left = raw[0]
    let rights = raw[1].split(' ')
    for right in rights:
      graph.addConnection(left, right)

  var i = 0
  while true:
    var newG = graph
    let (n, sizes) = getMinCut(newG)
    if n == 3:
      echo "Iteration ", i, ": ", n, " ", sizes, " ", sizes.foldl(a * b)
      break
    inc i

when isMainModule:
  main()