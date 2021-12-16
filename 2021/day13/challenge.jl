using Test


function print_map(dot_dict)
    max_i = maximum(map(x -> x[1], collect(keys(dot_dict))))
    max_j = maximum(map(x -> x[2], collect(keys(dot_dict))))
    for j = 0:max_j
        for i = 0:max_i
            character = get(dot_dict, [i, j], '.')
            print(character)
        end
        println()
    end
end


function fold_map(dot_dict, fold_instruction)
    new_dot_dict = Dict{Array{Int, 1}, Char}()
    for key in keys(dot_dict)
        if fold_instruction[1] == "x"
            if key[1] > fold_instruction[2]
                new_x = 2*fold_instruction[2] - key[1]
                new_dot_dict[[new_x, key[2]]] = '#'
            else
                new_dot_dict[key] = '#'
            end
        elseif fold_instruction[1] == "y"
            if key[2] > fold_instruction[2]
                new_y = 2*fold_instruction[2] - key[2]
                new_dot_dict[[key[1], new_y]] = '#'
            else
                new_dot_dict[key] = '#'
            end
        end
    end
    return new_dot_dict
end


f = open("input.txt", "r")

pattern = r"(\d+),(\d+)|([xy])=(\d+)"

fold_instructions = Array[]
dot_dict = Dict{Array{Int, 1}, Char}()

while !eof(f)
    line = readline(f)
    matches = match(pattern, line)
    if matches == nothing
        continue
    elseif matches.captures[1] != nothing
        dot_dict[map(x -> parse(Int, x), matches.captures[1:2])] = '#'
        # push!(dot_set, )
    elseif matches.captures[3] != nothing
        push!(fold_instructions, [matches.captures[3], parse(Int, matches.captures[4])])
    else
        @test false
    end
end

close(f)

# print_map(dot_dict)
# for fold in fold_instructions
#     @show fold
# end

global new_dict = copy(dot_dict)
for instruction in fold_instructions
    global new_dict = fold_map(new_dict, instruction)
end
print_map(new_dict)
# new_dict2 = fold_map(new_dict1, fold_instructions[2])
# print_map(new_dict2)
