import std/strutils

import part1

proc str_replace(s: string, i: int, c: char): string =
  result = s[0..(i-1)] & c & s[(i+1)..^1]

iterator get_new_problems(problem: seq[string]): seq[string] =
    for i, row in problem:
      for j, c in row:
        var new_problem = problem
        case c
        of '.': new_problem[i] = str_replace(problem[i], j, '#')
        of '#': new_problem[i] = str_replace(problem[i], j, '.')
        else: echo "Should not happen"
        yield new_problem

proc main() =
  let file = readFile("input.txt")
  let lines = file.split()
  var problems: seq[seq[string]]
  problems.add(newSeq[string]())
  var i = 0
  for line in lines:
    if line != "":
      problems[i].add(line)
    else:
      problems.add(newSeq[string]())
      inc i

  var tot = 0
  for i, problem in problems:
    let (cols, rows) = solve_problem(problem)
    for new_problem in get_new_problems(problem):
      var (new_cols, new_rows) = solve_problem(new_problem)
      new_cols = new_cols - cols
      new_rows = new_rows - rows
      if card(new_cols) + card(new_rows) == 1:
        tot += get_solution_val(new_cols, new_rows)
        break
  echo tot


when isMainModule:
  main()