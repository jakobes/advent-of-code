
with open('input.txt', 'r') as fh:
    input_data = fh.readlines()

word_map = {}
for row_index, row in enumerate((r.strip() for r in input_data)):

    for column_index, character in enumerate(row):
        word_map[(row_index, column_index)] = character

max_row_index = max((e[0] for e in word_map))
max_col_index = max((e[1] for e in word_map))


def find_match(word_map, indices, target_word):
    word = ""
    for index in indices:
        character = word_map.get(index)
        if character is None:
            return False
        elif character not in target_word:
            return False
        else:
            word += character

    return word == target_word


def part1():
    target_word = "XMAS"
    num_xmas = 0
    for r in range(max_row_index + 1):
        for c in range(max_col_index + 1):
            forward_indices = ((r, c), (r, c + 1), (r, c + 2), (r, c + 3))
            if find_match(word_map, forward_indices, target_word):
                num_xmas += 1

            backward_indices = ((r, c), (r, c - 1), (r, c - 2), (r, c - 3))
            if find_match(word_map, backward_indices, target_word):
                num_xmas += 1

            downward_indices = ((r, c), (r + 1, c), (r + 2, c), (r + 3, c))
            if find_match(word_map, downward_indices, target_word):
                num_xmas += 1

            upward_indices = ((r, c), (r - 1, c), (r - 2, c), (r - 3, c))
            if find_match(word_map, upward_indices, target_word):
                num_xmas += 1

            lrd_diagonal_indices = ((r, c), (r + 1, c + 1), (r + 2, c + 2), (r + 3, c + 3))
            if find_match(word_map, lrd_diagonal_indices, target_word):
                num_xmas += 1

            rlu_diagonal_indices = ((r, c), (r - 1, c - 1), (r - 2, c - 2), (r - 3, c - 3))
            if find_match(word_map, rlu_diagonal_indices, target_word):
                num_xmas += 1

            lru_diagonal_indices = ((r, c), (r - 1, c + 1), (r - 2, c + 2), (r - 3, c + 3))
            if find_match(word_map, lru_diagonal_indices, target_word):
                num_xmas += 1

            rld_diagonal_indices = ((r, c), (r + 1, c - 1), (r + 2, c - 2), (r + 3, c - 3))
            if find_match(word_map, rld_diagonal_indices, target_word):
                num_xmas += 1

    print(num_xmas)


def part2():
    target_word = "MAS"
    num_xmas = 0
    for r in range(max_row_index + 1):
        for c in range(max_col_index + 1):
            lrd_diagonal = ((r - 1, c - 1), (r, c), (r + 1, c + 1))
            lrd_match = find_match(word_map, lrd_diagonal, target_word)

            rlu_diagonal = ((r + 1, c + 1), (r, c), (r - 1, c - 1))
            rlu_match = find_match(word_map, rlu_diagonal, target_word)

            lru_diagonal = ((r + 1, c - 1), (r, c), (r - 1, c + 1))
            lru_match = find_match(word_map, lru_diagonal, target_word)

            rld_diagonal = ((r - 1, c + 1), (r, c), (r + 1, c - 1))
            rld_match = find_match(word_map, rld_diagonal, target_word)

            case1 = lrd_match or rlu_match 
            case2 = lru_match or rld_match

            if case1 and case2:
                num_xmas += 1

    print(num_xmas)


if __name__ == "__main__":
    # part1()
    print(max_row_index + 1, max_col_index + 1)
    part2()


