from pathlib import Path
from functools import reduce

priorities = {chr(i + 38): i for i in range(27, 53)}
priorities.update({chr(i + 96): i for i in range(1, 27)})

# sum_of_priorities = 0
# with Path("input.txt").open() as infile:
#     for line in infile.readlines():
#         length = len(line)
#         left = set(line[:length//2])
#         right = set(line[length//2:])
#         sum_of_priorities += sum(map(
#             lambda x: priorities[x],
#             set(line[:length//2]) & set(line[length//2:])
#         ))
# print(sum_of_priorities)

with Path("input.txt").open("r") as infile:
    lines = infile.readlines()
    assert len(lines) % 3 == 0
    sum_of_priorities = 0
    for i in range(0, len(lines), 3):
        sum_of_priorities += sum(map(lambda x: priorities[x], reduce(lambda x, y: x & y, (set(lines[i + j].strip()) for j in range(3)))))
    print(sum_of_priorities)

    print(sum([sum(map(lambda x: priorities[x], reduce(lambda x, y: x & y, (set(lines[i + j].strip()) for j in range(3))))) for i in range(0, len(lines), 3)]))
