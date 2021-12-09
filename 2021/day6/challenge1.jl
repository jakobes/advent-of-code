using Test
using DataStructures


function model_fish(fish_list::Array{UInt8, 1}, max_days::Int64)::Array{UInt8, 1}
    for i = 1:max_days
        @show i
        new_fish = UInt8[]

        @inbounds for j = 1:length(fish_list)
            if fish_list[j] == 0
                fish_list[j] = UInt8(6)
                push!(new_fish, UInt8(8))
            else
                fish_list[j] -= 1
            end
        end
        fish_list = vcat(fish_list, new_fish)
    end
    return fish_list
end


function create_fish_dict(fish_list)
    fish_dict = DefaultDict{Int, Int}(0)
    for i = 1:length(fish_list)
        val = fish_list[i]
        fish_dict[val] += 1
    end
    return fish_dict
end


function optimised_model_fish(fish_dict, max_days)
    for i = 1:max_days
        @show i
        new_fish_dict = DefaultDict{Int, Int}(0)
        for (key, value) in fish_dict
            if key == 0
                new_fish_dict[8] += value
                new_fish_dict[6] += value
            else
                new_fish_dict[key - 1] = value
            end
        end
        fish_dict = new_fish_dict
    end
    return fish_dict
end


uint_test_fish_list = UInt8[3, 4, 3, 1, 2]
@time test_fishes_80 = model_fish(uint_test_fish_list, 80)
@test length(test_fishes_80) == 5934

test_fish_list = [3, 4, 3, 1, 2]
test_fish_dict = create_fish_dict(test_fish_list)
@time optimised_fish_dict = optimised_model_fish(test_fish_dict, 80)
num_fish = sum(values(optimised_fish_dict))
@test num_fish == 5934

@time optimised_fish_dict = optimised_model_fish(test_fish_dict, 256)
num_fish = sum(values(optimised_fish_dict))
@test num_fish == 26984457539

open("input.txt", "r") do f
    splitlines = split(readline(f), ",")
    global uint_fish_list = map(x -> parse(UInt8, x), splitlines)
    global fish_list = map(x -> parse(Int, x), splitlines)
end

fishes = model_fish(uint_fish_list, 80)
@show length(fishes)

fish_dict = create_fish_dict(fish_list)
more_fishes = optimised_model_fish(fish_dict, 256)
num_fish = sum(values(more_fishes))
@show num_fish
