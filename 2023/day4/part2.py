def get_card_points(card: str):
  _, numbers = card.split(': ')
  winning_text, mytext = numbers.split(' | ')
  winning_numbers = [int(v) for v in winning_text.split()]
  mynumbers = [int(v) for v in mytext.split() if int(v) in winning_numbers]
  return len(mynumbers)


def main():
  with open('input.txt') as f:
    lines = [l.strip() for l in f.readlines()]
  copies = [1] * len(lines)
  for i, line in enumerate(lines):
    points = get_card_points(line)
    for j in range(i + 1, min(i + 1 + points, len(lines))):
      copies[j] += copies[i]
  print(sum(copies))


if __name__ == '__main__':
  main()