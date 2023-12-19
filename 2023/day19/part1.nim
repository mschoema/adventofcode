import std/tables
import std/strutils


type
  Operator* = enum
    LessThan, GreaterThan
  Rule* = object
    def*: bool = false
    rid*: 0..3
    op*: Operator
    val*: int
  Part* = array[0..3, int]

proc parseRule(s: string): (Rule, string) =
  var dotidx = s.find(':')
  if dotidx == -1:
    result = (Rule(def: true), s)
  else:
    let dest = s[dotidx+1..^1]
    let rawrid = s[0]
    let rawop = s[1]
    let val = s[2..dotidx-1].parseInt
    var rid: 0..3
    var op: Operator
    case rawrid
    of 'x': rid = 0
    of 'm': rid = 1
    of 'a': rid = 2
    of 's': rid = 3
    else: echo "Should not happen"
    case rawop
    of '<': op = LessThan
    of '>': op = GreaterThan
    else: echo "Should not happen"
    result = (Rule(rid: rid, op: op, val: val), dest)

proc readWorkflows*(f: string): Table[string, seq[(Rule, string)]] =
  for line in lines(f):
    let raw = line[0..^2].split('{')
    var rules: seq[(Rule, string)]
    for rawrule in raw[1].split(','):
      rules.add(rawrule.parseRule)
    result[raw[0]] = rules

proc readParts(f: string): seq[Part] =
  for line in lines(f):
    let raw = line[1..^2].split(',')
    result.add([raw[0][2..^1].parseInt,
                raw[1][2..^1].parseInt,
                raw[2][2..^1].parseInt,
                raw[3][2..^1].parseInt])

proc passesRule(part: Part, rule: Rule): bool =
  if rule.def:
    result = true
  else:
    case rule.op
    of LessThan: result = part[rule.rid] < rule.val
    of GreaterThan: result = part[rule.rid] > rule.val

proc passesWorkflows(part: Part, workflows: Table[string, seq[(Rule, string)]]): bool =
  var currWorkflow = "in"
  while true:
    for (rule, dest) in workflows[currWorkflow]:
      if passesRule(part, rule):
        if dest == "A": return true
        elif dest == "R": return false
        else:
          currWorkflow = dest
          break

proc main() =
  let workflows = readWorkflows("input/workflows.txt")
  let parts = readParts("input/parts.txt")
  var tot = 0
  for part in parts:
    if passesWorkflows(part, workflows):
      tot += part[0] + part[1] + part[2] + part[3]
  echo tot

when isMainModule:
  main()