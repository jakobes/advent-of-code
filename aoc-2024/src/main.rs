mod days;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        println!("Usage: advent_of_code <day>");
        return;
    }

    let day = &args[1];
    match day.as_str() {
        "1" => days::day1::run(),
        _ => println!("Day {} not implemented", day),
    }
}
