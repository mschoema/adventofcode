def get_calibration_value(line):
  text_digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
  text_value = ''
  for c in line:
    if c in text_digits:
      text_value += c
      break
  for c in line[::-1]:
    if c in text_digits:
      text_value += c
      break
  value = int(text_value)
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