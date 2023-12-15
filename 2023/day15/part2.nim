import std/strutils
import std/tables

import part1

proc main() =
  let commands = readFile("input.txt").split(",")
  var hashmap: Table[int, OrderedTable[string, int]]
  for command in commands:
    if '=' in command:
      let s = command.split('=')
      let label = s[0]
      let flength = s[1].parseInt
      let h = hash_str(label)
      if hashmap.hasKeyorPut(h, {label: flength}.toOrderedTable):
        hashmap[h][label] = flength
    else:
      let label = command[0..^2]
      let h = hash_str(label)
      if hashmap.hasKey(h):
        hashmap[h].del(label)
        if hashmap[h].len == 0:
          hashmap.del(h)
  var tot = 0
  for h, t in hashmap.pairs:
    var i = 1
    for label, flength in t.pairs:
      tot += (h + 1) * i * flength
      inc i
  echo tot

when isMainModule:
  main()