import std/strutils
import std/sequtils

type
  Spring* = enum
    Unknown, Damaged, Operational

proc parseSpring*(c: char): Spring =
  case c
  of '?': result = Unknown
  of '#': result = Damaged
  of '.': result = Operational
  else: echo "Should not happen"

proc count_arrangements(springs: var seq[Spring], damaged: sink seq[int], idx: sink int = 0, damagedCount: sink int = 0): int = 
  while idx < springs.len:
    case springs[idx]
    of Unknown:
      springs[idx] = Damaged
      let cntDmg = count_arrangements(springs, damaged, idx, damagedCount)
      springs[idx] = Operational
      let cntoP = count_arrangements(springs, damaged, idx, damagedCount)
      springs[idx] = Unknown
      return cntDmg + cntOp
    of Damaged:
      inc damagedCount
      if damaged.len == 0 or damagedCount > damaged[0]:
        return 0
    of Operational:
      if damagedCount == 0:
        discard
      elif damagedCount == damaged[0]:
        damaged.delete(0)
        damagedCount = 0
      else:
        return 0
    inc idx
  if damaged.len == 0:
    return 1
  elif damaged.len == 1 and damagedCount == damaged[0]:
    return 1
  else:
    return 0


proc main() =
  var tot = 0
  for line in lines("input.txt"):
    let s = line.split(' ')
    var springs = s[0].map(parseSpring)
    let damaged = s[1].split(',').map(parseInt)
    tot += count_arrangements(springs, damaged)
  echo tot

when isMainModule:
  main()