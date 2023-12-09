def get_digit(d):
  digits_1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
  digits_2 = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  if d in digits_1:
    return d
  elif d in digits_2:
    return digits_1[digits_2.index(d)]
  print("Should not happen")

def get_calibration_value(line):
  digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
  min_i = len(line)
  min_digit = ''
  for d in digits:
    i = line.find(d)
    if (i != -1 and i < min_i):
      min_i = i
      min_digit = get_digit(d)
  max_i = -1
  max_digit = ''
  for d in digits:
    i = line.rfind(d)
    if (i != -1 and i > max_i):
      max_i = i
      max_digit = get_digit(d)
  value = int(min_digit + max_digit)
  return value


def main():
  tot = 0
  with open('input.txt') as f:
    for line in f:
      val = get_calibration_value(line)
      tot += val
  print(tot)

if __name__ == '__main__':
  main()