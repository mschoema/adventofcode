def get_card_points(card: str):
  _, numbers = card.split(': ')
  winning_text, mytext = numbers.split(' | ')
  winning_numbers = [int(v) for v in winning_text.split()]
  mynumbers = [int(v) for v in mytext.split() if int(v) in winning_numbers]
  return len(mynumbers)


def main():
  tot = 0
  with open('input_small.txt') as f:
    for line in f:
      points = get_card_points(line.strip())
      if points > 0:
        tot += pow(2, points - 1)
  print(tot)


if __name__ == '__main__':
  main()