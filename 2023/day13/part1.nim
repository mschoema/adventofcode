import std/algorithm
import std/sequtils
import std/strutils

proc get_symm_cols*(s: string): set[int8] =
  var cols: set[int8]
  for i in 1..high(s):
    let start_s = s[0..i-1].reversed.join
    let end_s = s[i..^1]
    if find(start_s, end_s) == 0 or find(end_s, start_s) == 0:
      incl(cols, i.int8)
  return cols


proc get_col*(problem: seq[string], col: Natural): string =
  for row in problem:
    result.add(row[col])


proc solve_problem*(problem: seq[string]): (set[int8], set[int8]) =

  var cols = get_symm_cols(problem[0])
  for i in 1..high(problem):
    let cols_i = get_symm_cols(problem[i])
    cols = cols * cols_i
    if card(cols) == 0:
      break

  var rows = get_symm_cols(get_col(problem, 0))
  for i in 1..high(problem[0]):
    let rows_i = get_symm_cols(get_col(problem, i))
    rows = rows * rows_i
    if card(rows) == 0:
      break

  return (cols, rows)

proc get_solution_val*(cols: set[int8], rows: set[int8]): int =
  if card(cols) == 1:
    result = toSeq(cols)[0].int
  else:
    result = toSeq(rows)[0].int * 100

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
    tot += get_solution_val(cols, rows)
  echo tot


when isMainModule:
  main()