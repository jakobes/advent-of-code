from functools import partial, cmp_to_key

def parse_file(content):
    part1, part2 = content.strip().split('\n\n')
    
    pairs = [tuple(map(int, line.split('|'))) for line in part1.split('\n')]
    
    lists = [list(map(int, line.split(','))) for line in part2.split('\n')]
    
    return pairs, lists


def is_in_order(update, rule_map):
    seen = set()
    for page_number in update:
        seen.add(page_number)
        if (rule := rule_map.get(page_number)) is None:
            continue
        if len(rule.intersection(seen)) != 0:
            return False

    return True


def find_midle_number(update):
    return update[len(update) // 2] # zero indexed


def part1(rule_list, update_list):

    middle_sum = 0
    for update in update_list:
        if is_in_order(update, rules):
            middle_number = find_midle_number(update)
            middle_sum += middle_number
    
    print(middle_sum)


def find_next_number(remaining_numbers, rule_map):
    """Find a number less than all the others"""
    if len(remaining_numbers) == 1:
        return next(iter(remaining_numbers))

    for number in remaining_numbers:
        for other_number in remaining_numbers:
            if other_number == number:
                continue
            rule = rule_map.get(other_number)
            if rule is None:
                continue
            if number in rule:
                break
        else:
            return number

    raise RuntimeError()


def custom_sort(update, rule_map):
    sorted_update = []
    remaining_numbers = set(update)
    while len(remaining_numbers) > 0:
        next_number = find_next_number(remaining_numbers, rule_map)
        sorted_update.append(next_number)
        remaining_numbers.remove(next_number)

    return sorted_update


def part2(rule_map, update_list):
    middle_sum = 0
    for update in update_list:
        if not is_in_order(update, rule_map):
            sorted_update = custom_sort(update, rule_map)
            middle_number = find_midle_number(sorted_update)
            middle_sum += middle_number

    print(middle_sum)


if __name__ == "__main__":
    with open('input.txt', 'r') as ifh:
        rule_list, update_list, = parse_file(ifh.read())

        rule_map = {}
        for entry in rule_list:
            rule_map.setdefault(entry[0], set()).add(entry[1])

        part2(rule_map, update_list)
