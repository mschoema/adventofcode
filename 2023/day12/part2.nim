import std/strutils
import std/sequtils
import std/tables

when compileOption("profiler"):
  import nimprof

import part1

var map: Table[(Spring, seq[int], int, int), int]

proc count_arrangements(springs: var seq[Spring], damaged: sink seq[int], idx: sink int = 0, damagedCount: sink int = 0): int = 
  while idx < springs.len:
    case springs[idx]
    of Unknown:
      if damaged.len == 0:
        discard
      elif damagedCount == 0:
        springs[idx] = Damaged
        var cntDmg: int
        if map.hasKey((springs[idx], damaged, idx, damagedCount)):
          cntDmg = map[(springs[idx], damaged, idx, damagedCount)]
        else:
          cntDmg = count_arrangements(springs, damaged, idx, damagedCount)
          map[(springs[idx], damaged, idx, damagedCount)] = cntDmg
        springs[idx] = Operational
        var cntOp: int
        if map.hasKey((springs[idx], damaged, idx, damagedCount)):
          cntOp = map[(springs[idx], damaged, idx, damagedCount)]
        else:
          cntOp = count_arrangements(springs, damaged, idx, damagedCount)
          map[(springs[idx], damaged, idx, damagedCount)] = cntOp
        springs[idx] = Unknown
        return cntDmg + cntOp
      elif damaged[0] > damagedCount:
        inc damagedCount
      elif damaged[0] == damagedCount:
        damaged.delete(0)
        damagedCount = 0
      else:
        return 0
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
    map = initTable[(Spring, seq[int], int, int), int]()
    let s = line.split(' ')
    var s1 = s[0].map(parseSpring)
    let su = newSeqWith(1, Unknown)
    var springs = concat(s1, su, s1, su, s1, su, s1, su, s1)
    let d1 = s[1].split(',').map(parseInt)
    let damaged = concat(d1, d1, d1, d1, d1)
    let cnt = count_arrangements(springs, damaged)
    tot += cnt
  echo tot

when isMainModule:
  main()