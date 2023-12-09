def game_power(game: str):
  double_dot = game.find(':')
  game = game[double_dot + 2:]
  moves = [g.strip() for g in game.split(';')]

  red = 0
  green = 0
  blue = 0
  for move in moves:
    colors = [c.strip() for c in move.split(',')]
    for color in colors:
      val, name = color.split(' ')
      if name == 'red':
        red = max(red, int(val))
      elif name == 'green':
        green = max(green, int(val))
      elif name == 'blue':
        blue = max(blue, int(val))
  return red * green * blue


def main():
  tot = 0
  with open('input.txt') as f:
    for game in f:
      tot += game_power(game)
  print(tot)


if __name__ == '__main__':
  main()