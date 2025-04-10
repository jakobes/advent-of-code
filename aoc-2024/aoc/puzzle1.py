from collections import Counter


def load_data(filename):
    with open(filename) as file:
        list1, list2 = zip(*[map(int, row.split()) for row in file])
    return list(list1), list(list2)


def calculate_total_distance(list1, list2):
    return sum(abs(a - b) for a, b in zip(sorted(list1), sorted(list2)))


def calculate_similarity_score(list1, list2_totals):
    return sum(x * list2_totals.get(x, 0) for x in list1)


def main(filename):
    list1, list2 = load_data(filename)
    
    total_distance = calculate_total_distance(list1, list2)
    print(f"Total Distance: {total_distance}")
    
    right_list_totals = dict(Counter(list2))
    print("List 2 Totals:", right_list_totals)
    
    similarity_score = calculate_similarity_score(list1, right_list_totals)
    print(f"Similarity Score: {similarity_score}")


if __name__ == "__main__":
    main('test_input.txt')
    main('input.txt')
