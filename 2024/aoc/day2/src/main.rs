use std::fs::File;
use std::io::{self, BufRead, BufReader};

fn parse_input(filename: &str) -> io::Result<Vec<Vec<i32>>> {
    let file = File::open(filename)?;
    let reader = BufReader::new(file);

    let mut result = Vec::new();

    for line in reader.lines() {
        let line = line?;
        let row: Vec<i32> = line
            .split_whitespace()
            .filter_map(|s| s.parse().ok())
            .collect();

        result.push(row);
    }

    Ok(result)
}

fn is_increasing(vec: &Vec<i32>) -> bool {
    vec.windows(2).all(|w| w[1] > w[0])
}

fn is_decreasing(vec: &Vec<i32>) -> bool {
    vec.windows(2).all(|w| w[1] < w[0])
}

fn has_valid_difference(vec: &Vec<i32>) -> bool {
    vec.windows(2)
        .map(|w| (w[1] - w[0]).abs())
        .all(|diff| diff >= 1 && diff <= 3)
}

fn safe_level(vec: &Vec<i32>) -> bool {
    (is_increasing(vec) || is_decreasing(vec)) && has_valid_difference(vec)
}

fn problem_dampener_safe_level(vec: &Vec<i32>) -> bool {
    for skip_index in 0..vec.len() {
        let sub_vec: Vec<i32> = vec
            .iter()
            .enumerate()
            .filter(|&(i, _)| i != skip_index)
            .map(|(_, &value)| value)
            .collect();

        if safe_level(&sub_vec) {
            return true;
        }
    }

    false
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let is_test = false;

    let input_file_path = if is_test {
        "input_data/test_input.txt"
    } else {
        "input_data/input.txt"
    };

    let data = parse_input(input_file_path)?;

    let mut num_safe_rows: i32 = 0;
    let mut num_safe_rows_with_dampener: i32 = 0;
    for row in &data {
        if safe_level(row) {
            num_safe_rows += 1;
        }

        if problem_dampener_safe_level(row) {
            num_safe_rows_with_dampener += 1
        }
    }
    println!("Num safe rows: {num_safe_rows}");
    println!("Num safe rows: {num_safe_rows_with_dampener}");

    Ok(())
}
