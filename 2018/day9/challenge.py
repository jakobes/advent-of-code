import collections


def play_marbles(num_players, max_marble_value):
    player_scores = collections.defaultdict(int)
    marble_deque = collections.deque([0])

    for marble in range(1, max_marble_value + 1):
        if marble % 23 == 0:
            marble_deque.rotate(7)
            player_scores[marble % num_players] += marble + marble_deque.pop()
            marble_deque.rotate(-1)
        else:
            marble_deque.rotate(-1)
            marble_deque.append(marble)

    return max(player_scores.values()) if len(player_scores) else 0


assert play_marbles(9, 25) == 32
assert play_marbles(10, 1618) == 8317
assert play_marbles(13, 7999) == 146373
assert play_marbles(17, 1104) == 2764
assert play_marbles(21, 6111) == 54718
assert play_marbles(30, 5807) == 37305


# 48.5 ms
max_score = play_marbles(447, 71510)
print(max_score)


# 1.63 s
max_score = play_marbles(447, 71510*100)
print(max_score)
