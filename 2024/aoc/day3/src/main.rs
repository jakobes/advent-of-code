use anyhow::{anyhow, Context, Result};
use regex::Regex;
use std::fs;

fn read_file(filename: &str) -> Result<String> {
    fs::read_to_string(filename).with_context(|| format!("Failed to read file: {filename}"))
}

fn part1(input: &str) -> Result<Vec<u32>> {
    let pattern = r"mul\(([0-9]{1,3}),([0-9]{1,3})\)";
    let regex = Regex::new(pattern).context("Failed to compile regex pattern")?;
    let mut results = Vec::new();

    for cap in regex.captures_iter(input) {
        let x = cap[1]
            .parse::<u32>()
            .with_context(|| format!("Failed to parse number."))?;
        let y = cap[2]
            .parse::<u32>()
            .with_context(|| format!("Failed to parse number."))?;
        results.push(x * y);
    }

    Ok(results)
}

fn part2(input: &str) -> Result<Vec<u32>> {
    let pattern = r"mul\(([0-9]{1,3}),([0-9]{1,3})\)|(do(n't)?\(\))";
    let regex = Regex::new(pattern).context("Failed to compile regex pattern")?;

    let mut results = Vec::new();
    let mut include = true;

    for caps in regex.captures_iter(input) {
        let (cap1, cap2, cap3) = (caps.get(1), caps.get(2), caps.get(3));

        match (cap1, cap2, cap3) {
            (Some(a), Some(b), _) if include => {
                let x = a
                    .as_str()
                    .parse::<u32>()
                    .context("Failed to parse number")?;
                let y = b
                    .as_str()
                    .parse::<u32>()
                    .context("Failed to parse number")?;
                results.push(x * y);
            }
            (Some(_), Some(_), _) if !include => {
                // Matching pattern but skipped due to include flag
                // You can optionally log here if desired
            }
            (_, _, Some(do_call)) => match do_call.as_str() {
                "do()" => include = true,
                "don't()" => include = false,
                other => return Err(anyhow!("Unexpected do-call: {}", other)),
            },
            _ => {
                return Err(anyhow!(
                    "Unexpected captures: cap1={:?}, cap2={:?}, cap3={:?}",
                    cap1.map(|m| m.as_str()),
                    cap2.map(|m| m.as_str()),
                    cap3.map(|m| m.as_str())
                ));
            }
        }
    }

    //     for caps in regex.captures_iter(input) {
    //         match (caps.get(1), caps.get(2), caps.get(3)) {
    //             (Some(a), Some(b), _) if include => {
    //                 let x = a
    //                     .as_str()
    //                     .parse::<u32>()
    //                     .context("Failed to parse number")?;
    //                 let y = b
    //                     .as_str()
    //                     .parse::<u32>()
    //                     .context("Failed to parse number")?;
    //                 results.push(x * y);
    //             }
    //             (_, _, Some(do_call)) => match do_call.as_str() {
    //                 "do()" => include = true,
    //                 "don't()" => include = false,
    //                 other => return Err(anyhow!("Unexpected do-call: {}", other)),
    //             },
    //             unexpected => return Err(anyhow!("Unexpected match structure: {:?}", unexpected)),
    //         }
    //     }
    //
    Ok(results)
}

fn main() -> Result<()> {
    let input = read_file("input_data/input.txt")?;

    // match part1(input.as_str()) {
    //     Ok(results) => {
    //         println!("Total sum: {}", results.iter().sum::<u32>());
    //         Ok(())
    //     }
    //     Err(err) => {
    //         eprintln!("Error: {}", err);
    //         Err(err)
    //     }
    // }

    match part2(input.as_str()) {
        Ok(results) => {
            println!("Total sum: {}", results.iter().sum::<u32>());
            Ok(())
        }
        Err(err) => {
            eprintln!("Error: {}", err);
            Err(err)
        }
    }
}
