import std/sequtils
import std/tables

import part1

type
  PartRange = array[2, Part]

iterator applyWorkflow(p: PartRange, wf: seq[(Rule, string)]): (PartRange, string) =
  var part = p
  for (rule, dest) in wf:
    if rule.def:
      yield (part, dest)
    else:
      let minval = part[0][rule.rid]
      let maxval = part[1][rule.rid]
      case rule.op
      of LessThan:
        if maxval < rule.val:
          yield (part, dest)
          break
        elif minval >= rule.val:
          continue
        else:
          part[1][rule.rid] = rule.val - 1
          yield (part, dest)
          part[0][rule.rid] = rule.val
          part[1][rule.rid] = maxval
      of GreaterThan:
        if minval > rule.val:
          yield (part, dest)
          break
        elif maxval <= rule.val:
          continue
        else:
          part[0][rule.rid] = rule.val + 1
          yield (part, dest)
          part[0][rule.rid] = minval
          part[1][rule.rid] = rule.val


proc countPartRange(p: PartRange): int =
  result = 1
  for i in 0..3:
    result *= (p[1][i] - p[0][i] + 1)

proc main() =
  let workflows = readWorkflows("input/workflows.txt")
  let startPart: PartRange = [[1, 1, 1, 1], [4000, 4000, 4000, 4000]]
  var parts: seq[(PartRange, string)] = [(startPart, "in")].toSeq
  var tot = 0
  while parts.len > 0:
    var (part, w) = parts.pop()
    for (newPart, nextW) in applyWorkflow(part, workflows[w]):
      if nextW == "A":
        tot += countPartRange(newPart)
      elif nextW == "R": discard
      else: parts.add((newPart, nextW))
  echo tot


when isMainModule:
  main()