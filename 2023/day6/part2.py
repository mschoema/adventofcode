from part1 import compute_val

def main():
  with open('input.txt') as f:
    lines = f.readlines()
  time = int(''.join(lines[0].strip().split(':')[1].split()))
  distance = int(''.join(lines[1].strip().split(':')[1].split()))
  print(compute_val(time, distance))


if __name__ == '__main__':
  main()