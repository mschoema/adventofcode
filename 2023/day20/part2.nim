import std/deques
import std/math
import std/strutils
import std/tables

import part1

proc main() =
  let raw = readFile("input.txt").split('\n')
  var network: OrderedTable[string, Module]
  for line in raw:
    let s = line.split(" -> ")
    let next = s[1].split(", ")
    case s[0][0]
    of 'b': network[s[0]] = Broadcaster(next: next)
    of '%': network[s[0][1..^1]] = FlipFlop(next: next)
    of '&': network[s[0][1..^1]] = Conjunction(next: next)
    else: echo "Should not happen"
  network["button"] = Button(next: "broadcaster")
  network["output"] = Output()
  for line in raw:
    let s = line.split(" -> ")
    let next = s[1].split(", ")
    var module: string
    case s[0][0]
    of 'b': module = s[0]
    of '%': module = s[0][1..^1]
    of '&': module = s[0][1..^1]
    else: echo "Should not happen"
    for n in next:
      if n in network:
        addPrev(network[n], module)
  var cnt = 0
  var dd, fh, xp, fc: int
  var fdd, ffh, fxp, ffc: bool = false
  while true:
    cnt += 1
    var pulses = [("button", "broadcaster", Low)].toDeque
    var l, h = 0
    while pulses.len > 0:
      let (fr, to, pulse) = pulses.popFirst()
      if fr == "dd"and pulse == High and not fdd:
        dd = cnt
        fdd = true
      if fr == "fh"and pulse == High and not ffh:
        fh = cnt
        ffh = true
      if fr == "xp"and pulse == High and not fxp:
        xp = cnt
        fxp = true
      if fr == "fc"and pulse == High and not ffc:
        fc = cnt
        ffc = true
      case pulse
      of Low: l += 1
      of High: h += 1
      if to in network:
        for (nextTo, nextPulse) in processModule(fr, network[to], pulse):
          pulses.addLast((to, nextTo, nextPulse))
    if fdd and ffh and fxp and ffc:
      break
  echo lcm([dd, fh, xp, fc])


when isMainModule:
  main()