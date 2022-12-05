from pathlib import Path


def part1(ifname):
    with Path(ifname).open("r") as infile:
        count = 0
        for p1, p2 in map(lambda x: x.split(","), infile):
            p1_lower, p1_upper = tuple(map(int, p1.split("-")))
            p2_lower, p2_upper = tuple(map(int, p2.split("-")))
            if p1_lower <= p2_lower and p1_upper >= p2_upper:
                count += 1
            elif p2_lower <= p1_lower and p2_upper >= p1_upper:
                count += 1
        return count


def part2(ifname):
    with Path(ifname).open("r") as infile:
        count = 0
        for p1, p2 in map(lambda x: x.split(","), infile):
            p1_lower, p1_upper = tuple(map(int, p1.split("-")))
            p2_lower, p2_upper = tuple(map(int, p2.split("-")))

            if p1_lower <= p2_lower and p1_upper >= p2_lower:
                count += 1
            elif p1_lower <= p2_upper and p1_upper >= p2_upper:
                count += 1
            elif p2_lower <= p1_lower and p2_upper >= p1_lower:
                count += 1
            elif p2_lower <= p1_upper and p2_upper >= p1_upper:
                count += 1

        return count

foo = part2("input.txt")
print(foo)
