def compute_val(t, d):
  cnt = 0
  for i in range(t):
    if i * (t-i) > d:
      cnt += 1
  return cnt

def main():
  with open('input.txt') as f:
    lines = f.readlines()
  times = [int(t) for t in lines[0].strip().split(':')[1].split()]
  distances = [int(d) for d in lines[1].strip().split(':')[1].split()]
  tot = 1
  for i in range(len(times)):
    tot *= compute_val(times[i], distances[i])
  print(tot)


if __name__ == '__main__':
  main()