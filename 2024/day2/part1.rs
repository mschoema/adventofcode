use std::fs::read_to_string;

fn is_safe(levels: &Vec<i32>) -> bool {
    if levels.len() < 2 {return true;}
    if levels[0] == levels[1] {return false;}
    let increasing = levels[0] > levels[1];
    for (i, _level) in levels.into_iter().enumerate() {
        if i == 0 {continue;}
        if levels[i-1] == levels[i] {return false;}
        if levels[i-1] > levels[i] {
            if !increasing || levels[i-1] - levels[i] > 3 {
                return false;
            }
        } else {
            if increasing || levels[i] - levels[i-1] > 3 {
                return false;
            }
        }
    }
    true
}

fn main() {
    let f = read_to_string("input.txt").unwrap();
    let mut tot = 0;
    for line in f.lines() {
        let levels = line.split_whitespace()
                         .map(|v| v.parse::<i32>()
                         .unwrap()).collect::<Vec<i32>>();
        if is_safe(&levels) {tot += 1};
    }
    println!("{:?}", tot);
}