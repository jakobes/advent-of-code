using Test


function convolve(state_vector::Vector{Int}, rule::Vector{Int})::Vector{Int}
    change_index_vector = Int[]

    for i in 1:length(state_vector) - length(rule)
        if state_vector[i:i + length(rule) - 1] == rule
            push!(change_index_vector, i + 2)
        end
    end
    return change_index_vector
end


function grow_plants(
    initial_state::Vector{Int},
    rule_set::Set{Vector{Int}},
    num_generations::Int,
    padding::Int = 0
)::Vector{Int}
    pots = copy(initial_state)
    if padding > 0
        prepend!(pots, zeros(Int, padding))
        append!(pots, zeros(Int, padding))
    end

    new_pots = zeros(Int, size(pots))

    for generation in 1:num_generations
        fill!(new_pots, 0)

        for rule in rule_set
            change_index_vector = convolve(pots, rule[1: end - 1])
            for index in change_index_vector
                new_pots[index] = rule[end]
            end
        end
        pots = copy(new_pots)
    end
    return pots
end


function read_file(filename="input.txt")
    file = readlines(filename)

    to_int(x) = ifelse(x == "#" || x == '#', 1, 0)
    pots = map(to_int, collect(match(r"[#.]+", file[1]).match))

    rule_set = Set{Vector{Int}}()
    for line in file[3: end]
        if line[end] == '#'
            rule = [to_int(i.match) for i in collect(eachmatch(r"[#.]", line))]
            push!(rule_set, rule)
        end
    end
    return pots, rule_set
end


function compute_sum(pots::Vector{Int}, offset::Int)::Int
    pot_sum = 0
    for i in eachindex(pots)
        if pots[i] != 0
            pot_sum += i - (offset + 1)
        end
    end
    return pot_sum
end


start_index = 3
len = 39
initial_state = Int[1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
                    1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]

rules = Set{Vector{Int}}([
    [0, 0, 0, 1, 1, 1],
    [0, 0, 1, 0, 0, 1],
    [0, 1, 0, 0, 0, 1],
    [0, 1, 0, 1, 0, 1],
    [0, 1, 0, 1, 1, 1],
    [0, 1, 1, 0, 0, 1],
    [0, 1, 1, 1, 1, 1],
    [1, 0, 1, 0, 1, 1],
    [1, 0, 1, 1, 1, 1],
    [1, 1, 0, 1, 0, 1],
    [1, 1, 0, 1, 1, 1],
    [1, 1, 1, 0, 0, 1],
    [1, 1, 1, 0, 1, 1],
    [1, 1, 1, 1, 0, 1]
])

pots = grow_plants(initial_state, rules, 20, 5)
@test compute_sum(pots, 5) == 325


# Partt 1
initial_state, rules = read_file()
offset = 50
pots = grow_plants(initial_state, rules, 0, offset)
@show pots
pot_sum = compute_sum(pots, offset)
@show pot_sum


# # Part 2
# initial_state, rules = read_file()
# offset = 300
# prev_sum = 0
# for i in 1:200
#     global prev_sum
#     pots = grow_plants(initial_state, rules, i, offset)
#     pot_sum = compute_sum(pots, offset)
#     @show i, pot_sum, pot_sum - prev_sum
#     prev_sum = pot_sum
# end
