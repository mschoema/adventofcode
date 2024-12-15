use std::fs::read_to_string;
use std::collections::HashMap;

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

    let mut second_counts = HashMap::new();

    for x in second.iter() {
        second_counts.entry(x).and_modify(|counter| *counter += 1).or_insert(1);
    }

    let mut tot = 0;
    for x in first.iter() {
        let value = second_counts.entry(x).or_insert(0);
        tot += x * (*value);
    }
    println!("{:?}", tot);
}