import re
from operator import mul
from functools import reduce


with open('input.txt', 'r') as fh:
    text = fh.read()

# matches = re.findall(r'mul\(([0-9]{1,3}),([0-9]{1,3})\)', text)
# print(sum((reduce(mul, map(int, m))) for m in matches))

part2_test_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
matches = re.findall(r"mul\(([0-9]{1,3}),([0-9]{1,3})\)|(do(n't)?\(\))", text)

enables = True
cummul = 0
for m in matches:
    if m[0] != '' and m[1] != '' and enables:
        cummul += reduce(mul, map(int, m[:2]))
    elif m[2] == 'do()':
        enables = True
    elif m[2] == "don't()":
        enables = False


print(cummul)


# for match in matches:
#     print("Full match:", match[0])  # Entire matched string
#     print("Specific capture groups:", match[1:])  # Other capture groups


# enables = True
# for m in part2_matches:
# elif "don't()" in m:
#         enables = Fale
# =         print(m[0])
