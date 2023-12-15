import std/strutils

proc hash_str*(command: string): int =
  for c in command:
    result += ord c
    result = (result * 17) mod 256

proc main() =
  let commands = readFile("input.txt").split(",")
  var tot = 0
  for command in commands:
    tot += hash_str(command)
  echo tot

when isMainModule:
  main()