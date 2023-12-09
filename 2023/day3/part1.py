def get_adjacent(i, j, l, max_i, max_j):
  adjacent = []
  for x in range(max(0, i-1), min(max_i, i+2)):
    for y in range(max(0, j-1), min(max_j, j+l+1)):
      adjacent.append((x, y))
  return adjacent

def get_line_values(line):
  n = 0
  values = []
  positions = []
  lengths = []

  newline = ''
  curr_val = False
  curr_len = 1
  for i, l in enumerate(line + ' '):
    if l in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']:
      newline += l
      if not curr_val:
        n += 1
        curr_val = True
        positions.append(i)
      else:
        curr_len += 1
    else:
      if curr_val:
        newline += ' '
        curr_val = False
        lengths.append(curr_len)
        curr_len = 1
  if newline == '':
    return 0, [], [], []
  values = newline.strip().split(' ')
  values = [int(val) for val in values]
  return n, values, positions, lengths

def is_next_to_symbol(symbol_matrix, i, j, l):
  for (x, y) in get_adjacent(i, j, l, len(symbol_matrix), len(symbol_matrix[0])):
    if symbol_matrix[x][y]:
      return True
  return False

def main():
  symbol_matrix = []
  with open('input.txt') as f:
    for line in f:
      line = line.strip()
      symbol_matrix.append([])
      for s in line:
        symbol_matrix[-1].append(s not in ['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
  tot = 0
  with open('input.txt') as f:
    for i, line in enumerate(f):
      n, values, positions, lengths = get_line_values(line)
      for j in range(n):
        if is_next_to_symbol(symbol_matrix, i, positions[j], lengths[j]):
          tot += values[j]
  print(tot)

if __name__ == '__main__':
  main()