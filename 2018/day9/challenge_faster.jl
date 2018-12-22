using DataStructures
using Test


function play_marbles(num_players::Int, max_marble_value::Int)::Int
    player_scores = DefaultDict{Int, Int}(0)
    marble_vector = Int[0]

    ci = 1      # current index
    for marble in 1:max_marble_value
        if marble % 23 == 0
            ci = ci - 7 <= 0 ? length(marble_vector) + ci - 7 : ci - 7
            player_scores[marble % num_players] += marble + marble_vector[ci]
            deleteat!(marble_vector, ci)
        else
            ci = ci >= length(marble_vector) ? 2 : ci + 2
            insert!(marble_vector, ci, marble)
        end
    end
    return length(values(player_scores)) > 0 ? maximum(values(player_scores)) : 0
end


@test play_marbles(9, 25) == 32
@test play_marbles(10, 1618) == 8317
@test play_marbles(13, 7999) == 146373
@test play_marbles(17, 1104) == 2764
@test play_marbles(21, 6111) == 54718
@test play_marbles(30, 5807) == 37305

# 1.3
high_score = play_marbles(447, 71510)
@show high_score

# this sucks
high_score = play_marbles(447, 71510*100)
@show high_score
