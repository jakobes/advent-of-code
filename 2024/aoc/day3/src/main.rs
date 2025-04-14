use anyhow::{Context, Result};
use regex::Regex;
use std::fs;

fn read_file(filename: &str) -> Result<String> {
    fs::read_to_string(filename).with_context(|| format!("Failed to read file: {filename}"))
}

fn extract_and_calculate(input: &str) -> Result<Vec<u32>> {
    let pattern = r"mul\(([0-9]{1,3}),([0-9]{1,3})\)|(do(n't)?\(\))";
    let regex = Regex::new(pattern).context("Failed to compile regex pattern")?;

    let mut results = Vec::new();

    for cap in regex.captures_iter(input) {
        let x = cap[1]
            .parse::<u32>()
            .with_context(|| format!("Failed to [parse number."))?;
        let y = cap[2]
            .parse::<u32>()
            .with_context(|| format!("Failed to [parse number."))?;
        results.push(x * y);
    }

    Ok(results)
}

fn main() -> Result<()> {
    // let input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
    let input = read_file("input_data/input.txt")?;

    match extract_and_calculate(input.as_str()) {
        Ok(results) => {
            println!("Individual results: {:?}", results);
            println!("Total sum: {}", results.iter().sum::<u32>());
            Ok(())
        }
        Err(err) => {
            eprintln!("Error: {}", err);
            Err(err)
        }
    }
}
