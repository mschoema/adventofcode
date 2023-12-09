import std/math
import std/sequtils
import std/strutils

proc get_card_points*(line: string): int = 
  var numbers = line.split(':')[1]
  var split_numbers = numbers.split('|')
  var winning_numbers = split_numbers[0].splitWhitespace().map(parseInt)
  var mynumbers = split_numbers[1].splitWhitespace().map(parseInt)
  mynumbers.filterIt(it in winning_numbers).len()

proc main() =
  var tot = 0
  for line in lines("input_small.txt"):
    var points = get_card_points(line)
    if points > 0:
      tot += 2^(points - 1)
  echo tot

when isMainModule:
  main()