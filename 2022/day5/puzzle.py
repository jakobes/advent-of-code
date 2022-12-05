from pathlib import Path
import re


def part1():
    pattern = re.compile("(\d+)")
    stack_dict = dict()
    with Path("input.txt").open("r") as infile:
        for line in infile:
            if "1" in line:
                break
            for stack_num, i in enumerate(range(0, len(line), 4), start=1):
                crate = line[i + 1]
                if len(crate.strip()) == 0:
                    continue
                stack = stack_dict.get(stack_num, [])
                stack.append(crate)
                stack_dict[stack_num] = stack

        for line in infile:
            if len(line.strip()) == 0:
                continue
            num_crate, from_crate, to_crate = list(map(int, pattern.findall(line)))
            for _ in range(num_crate):
                from_stack = stack_dict[from_crate]
                crate = from_stack.pop(0)
                stack_dict[from_crate] = from_stack

                target_stack = stack_dict[to_crate]
                target_stack.insert(0, crate)
                stack_dict[to_crate] = target_stack

            for crate_index, crate in stack_dict.items():
                print(crate_index, crate)
            print()

        answer = "".join((stack_dict[key][0] for key in sorted(stack_dict.keys())))
        print(answer)



def part2(ifname):
    pattern = re.compile("(\d+)")
    stack_dict = dict()
    with Path(ifname).open("r") as infile:
        for line in infile:
            if "1" in line:
                break
            for stack_num, i in enumerate(range(0, len(line), 4), start=1):
                crate = line[i + 1]
                if len(crate.strip()) == 0:
                    continue
                stack = stack_dict.get(stack_num, [])
                stack.append(crate)
                stack_dict[stack_num] = stack

        for line in infile:
            if len(line.strip()) == 0:
                continue
            num_crate, from_crate, to_crate = list(map(int, pattern.findall(line)))
            from_stack = stack_dict[from_crate]
            target_stack = stack_dict[to_crate]

            stack_list = []
            for _ in range(num_crate):
                stack_list.append(from_stack.pop(0))

            stack_dict[from_crate] = from_stack
            for e in stack_list[::-1]:
                target_stack.insert(0, e)
            stack_dict[to_crate] = target_stack

            for key in sorted(stack_dict.keys()):
                print(stack_dict[key]) 
            print()

        answer = "".join((stack_dict[key][0] for key in sorted(stack_dict.keys())))
        print(answer)


part2("input.txt")
