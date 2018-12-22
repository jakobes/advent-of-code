using DataStructures
using Test


function play_marbles(num_players::Int, num_marbles::Int)::Int
    player_scores = DefaultDict{Int, Int}(0)

    marble_vector = Int[0]

    for marble in 1:num_marbles
        if marble % 23 == 0
            marble_vector = circshift(marble_vector, 7)     # counter clockwise shift
            player_scores[marble % num_players] += marble + pop!(marble_vector)
            marble_vector = circshift(marble_vector, -1)    # clockwise shift
        else
            marble_vector = circshift(marble_vector, -1)    # clockwise shift
            push!(marble_vector, marble)
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

# 3.75 
high_score = play_marbles(447, 71510)
@show high_score

# This sucks even more
high_score = play_marbles(447, 71510*100)
@show high_score
