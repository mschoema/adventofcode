RED_MAX = 12
GREEN_MAX = 13
BLUE_MAX = 14

MAX_DICT = {'red': RED_MAX, 'green': GREEN_MAX, 'blue': BLUE_MAX}


def move_is_possible(move: str):
  colors = [c.strip() for c in move.split(',')]
  for color in colors:
    val, name = color.split(' ')
    if int(val) > MAX_DICT.get(name):
      return False
  return True


def game_is_possible(game: str):
  double_dot = game.find(':')
  game = game[double_dot + 2:]
  moves = [g.strip() for g in game.split(';')]
  for move in moves:
    if not move_is_possible(move):
      return False
  return True


def main():
  tot = 0
  with open('input.txt') as f:
    game_id = 1
    for game in f:
      if game_is_possible(game):
        tot += game_id
      game_id += 1
  print(tot)


if __name__ == '__main__':
  main()