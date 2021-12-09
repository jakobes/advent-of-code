using Test


function compute_alignment(positions_array::Array{Int, 1})::Dict{Int, Int}
    min_position = minimum(positions_array)
    max_position = maximum(positions_array)

    cost_dict = Dict{Int, Int}()
    for i = min_position:max_position
        cost_dict[i] = sum(abs.(positions_array .- i))
    end
    return cost_dict
end


function compute_alignment_part2(positions_array::Array{Int, 1})::Dict{Int, Int}
    min_position = minimum(positions_array)
    max_position = maximum(positions_array)

    cost_dict = Dict{Int, Int}()
    for i = min_position:max_position
        distance_array = abs.(positions_array .- i)
        cost_array = Array{Int, 1}(undef, length(distance_array))
        for j = 1:length(distance_array)
            cost_array[j] = sum(1:distance_array[j])
        end
        cost_dict[i] = sum(cost_array)
        @show i, cost_dict[i]
    end
    return cost_dict
end


minkey(d) = reduce((x, y) -> d[x] ≤ d[y] ? x : y, keys(d))

test_positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
test_cost_dict = compute_alignment(test_positions)
@test minkey(test_cost_dict) == 2
@test minimum(values(test_cost_dict)) == 37


open("input.txt", "r") do f
    global positions = map(x -> parse(Int, x), split(readline(f), ","))
end


cost_dict = compute_alignment(positions)
@show minimum(values(cost_dict))

# part 2
test_cost_dict2 = compute_alignment_part2(test_positions)
@test minkey(test_cost_dict2) == 5
@test minimum(values(test_cost_dict2)) == 168

@show minimum(values(compute_alignment_part2(positions)))
