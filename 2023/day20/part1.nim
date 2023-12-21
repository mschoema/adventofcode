import std/deques
import std/sets
import std/strutils
import std/tables

type
  Pulse* = enum
    Low, High
  Module* = ref object of RootObj
  Button* = ref object of Module
    next*: string
  Broadcaster* = ref object of Module
    next*: seq[string]
  FlipFlop* = ref object of Module
    state*: Pulse = Low
    next*: seq[string]
  Conjunction* = ref object of Module
    states*: OrderedTable[string, Pulse]
    next*: seq[string]
  Output* = ref object of Module

proc addPrev*(module: var Module, prev: string) =
  if module of Conjunction:
    Conjunction(module).states[prev] = Low
  else: discard

proc setState(module: var Module, prev: string, state: Pulse) =
  if module of Conjunction:
    Conjunction(module).states[prev] = state
  else: discard

proc allHigh(module: Conjunction): bool =
  result = true
  for val in module.states.values:
    if val == Low:
      result = false
      break

proc printNetwork(network: OrderedTable[string, Module]) =
  for k, v in network.pairs():
    if v of Button:
      echo k, " Button ", Button(v)[]
    elif v of Broadcaster:
      echo k, " Broadcaster ", Broadcaster(v)[]
    elif v of FlipFlop:
      echo k, " FlipFlop ", FlipFlop(v)[]
    elif v of Conjunction:
      echo k, " Conjunction ", Conjunction(v)[]
    elif v of Output:
      echo k, " Output ", Output(v)[]
    else: echo "Should not happen (other)"

iterator processModule*(prev: string, module: var Module, pulse: Pulse): (string, Pulse) =
  if module of Button: echo "Should not happen (button)"
  elif module of Broadcaster:
    for next in Broadcaster(module).next:
      yield (next, pulse)
  elif module of FlipFlop:
    case pulse
    of Low:
      case FlipFlop(module).state
      of Low: FlipFlop(module).state = High
      of High: FlipFlop(module).state = Low
      for next in FlipFlop(module).next:
        yield (next, FlipFlop(module).state)
    of High: discard
  elif module of Conjunction:
    Conjunction(module).states[prev] = pulse
    var outPulse: Pulse = High
    if allHigh(Conjunction(module)):
      outPulse = Low
    for next in Conjunction(module).next:
      yield (next, outPulse)
  elif module of Output: discard
  else: echo "Should not happen (other)"

proc getState(network: OrderedTable[string, Module]): seq[Pulse] =
  for s, m in network.pairs():
    if m of FlipFlop:
      result.add(FlipFlop(m).state)
    elif m of Conjunction:
      for p in Conjunction(m).states.values():
        result.add(p)

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
  var ls: seq[int]
  var hs: seq[int]
  var stateSet: HashSet[seq[Pulse]]
  while true:
    var pulses = [("button", "broadcaster", Low)].toDeque
    var l, h = 0
    while pulses.len > 0:
      let (fr, to, pulse) = pulses.popFirst()
      case pulse
      of Low: l += 1
      of High: h += 1
      if to in network:
        for (nextTo, nextPulse) in processModule(fr, network[to], pulse):
          pulses.addLast((to, nextTo, nextPulse))
    let state = getState(network)
    if state in stateSet:
      break
    else:
      stateSet.incl(state)
      ls.add(l)
      hs.add(h)
      cnt += 1
    if cnt == 1000:
      break
  var lows, highs: int = 0
  for i in 1..1000:
    lows += ls[(i - 1) mod cnt]
    highs += hs[(i - 1) mod cnt]
  echo lows * highs

when isMainModule:
  main()