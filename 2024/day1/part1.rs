use std::fs::read_to_string;

fn main() {
    let mut first = Vec::new();
    let mut second = Vec::new();

    let binding = read_to_string("input.txt").unwrap();
    for line in binding.lines() {
        let parts = line.split_whitespace().collect::<Vec<&str>>();
        first.push(parts[0].parse::<i32>().unwrap());
        second.push(parts[1].parse::<i32>().unwrap());
    }

    first.sort();
    second.sort();

    let mut tot = 0;
    for (x, y) in first.iter().zip(second.iter()) {
        if y > x {
            tot += y - x;
        } else {
            tot += x - y;
        }
    }
    println!("{:?}", tot);
}