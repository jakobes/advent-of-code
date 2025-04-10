use std::io::{BufRead, BufReader};
use regex::Regex;



fn parse_two_columns(filename: &str) -> (Vec<i32>, Vec<i32>) {
    let pattern = Regex::new(r"(\d+)\s+(\d+)").unwrap();
    let (mut left, mut right) = (Vec::new(), Vec::new());
    
    BufReader::new(std::fs::File::open(filename).expect(&format!("Failed to open file: {}", filename))))
        .lines()
        .filter_map(|line| pattern.captures(&line.ok()?))
        .for_each(|capture| {
            left.push(capture[1].parse().unwrap());
            right.push(capture[2].parse().unwrap());
        });
    
    (left, right)
}
