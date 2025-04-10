use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};

fn load_data(filename: &str) -> Result<(Vec<i32>, Vec<i32>), std::io::Error> {
    let file = File::open(filename)?;
    let reader = BufReader::new(file);

    let mut list1 = Vec::new();
    let mut list2 = Vec::new();

    for line in reader.lines() {
        let line = line?;
        let parts: Vec<i32> = line
            .split_whitespace()
            .map(|s| s.parse().expect("Failed to parse number"))
            .collect();

        if parts.len() == 2 {
            list1.push(parts[0]);
            list2.push(parts[1]);
        }
    }

    Ok((list1, list2))
}

fn calculate_total_distance(list1: &[i32], list2: &[i32]) -> i32 {
    let mut sorted1 = list1.to_vec();
    let mut sorted2 = list2.to_vec();
    sorted1.sort();
    sorted2.sort();

    sorted1
        .iter()
        .zip(sorted2.iter())
        .map(|(a, b)| (a - b).abs())
        .sum()
}

fn calculate_similarity_score(list1: &[i32], list2_totals: &HashMap<i32, i32>) -> i32 {
    list1
        .iter()
        .map(|&x| x * list2_totals.get(&x).cloned().unwrap_or(0))
        .sum()
}

fn count_list_totals(list2: &[i32]) -> HashMap<i32, i32> {
    let mut totals = HashMap::new();
    for &num in list2 {
        *totals.entry(num).or_insert(0) += 1
    }
    totals
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let Ok((list1, list2)) = load_data("../test_input.txt") else {
        todo!()
    };

    let total_distance = calculate_total_distance(&list1, &list2);
    println!("Total distance: {}", total_distance);

    let right_list_totals = count_list_totals(&list2);
    let similarity_score = calculate_similarity_score(&list1, &right_list_totals);
    println!("Similarity score: {}", similarity_score);

    Ok(())
}
