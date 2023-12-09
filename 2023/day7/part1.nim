import std/algorithm
import std/strutils

type 
  Hand = tuple
    hand: string
    bid: int

  HandType = enum
    HighCard, OnePair, 
    TwoPair, TreeOfAKind, 
    FullHouse, FourOfAKind, 
    FiveOfAKind

const Cards: array[13, char] = ['A', 'K', 'Q', 'J',
  'T', '9', '8', '7', '6', '5', '4', '3', '2']

proc get_hand_type(h: Hand): HandType =
  var nums: seq[int]
  for i in low(Cards)..high(Cards):
    nums.add(count(h.hand, Cards[i]))
  nums.sort(Descending)
  case nums[0]
  of 5: FiveOfAKind
  of 4: FourOfAKind
  of 3:
    case nums[1]
    of 2: FullHouse
    else: TreeOfAKind
  of 2:
    case nums[1]
    of 2: TwoPair
    else: OnePair
  else: HighCard

proc cmp_hands(x, y: Hand): int =
  let type1 = get_hand_type(x)
  let type2 = get_hand_type(y)
  if type1 < type2:
    result = 1
  elif type1 > type2:
    result = -1
  else:
    for i in low(x.hand)..high(x.hand):
      result = cmp(Cards.find(x.hand[i]), Cards.find(y.hand[i]))
      if result != 0:
        return

proc main() =
  var hands: seq[Hand]
  for line in lines("input.txt"):
    let split_line = line.splitWhitespace()
    hands.add((split_line[0], parseInt(split_line[1])))
  hands.sort(cmp_hands, Descending)
  var tot  = 0
  for i, h in hands:
    tot += h.bid * (i + 1)
  echo tot



when isMainModule:
  main()