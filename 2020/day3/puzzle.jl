using DelimitedFiles
using DataStructures


function parse_map(string_map)
    # tree_map = Dict{Tuple{Int,Int}, Char}()
    tree_map = Set{Tuple{Int, Int}}()
    for i in 1:length(string_map)
        for j in 1:length(string_map[i])
            if string_map[i][j] == '#'
                push!(tree_map, (i, j))
            end
        end
    end
    return tree_map
end


function custom_mod(column, width)
    mod_result = mod(column, width)
    if mod_result == 0
        return width
    end
    return mod_result
end


function count_trees(tree_set, bottom, map_width, dc, dr)
    row = 1
    column = 1
    num_trees = 0
    while row <= bottom
        row += dr
        column = custom_mod(column + dc, map_width)
        if in((row, column), tree_set)
            num_trees += 1
        end
    end
    return num_trees
end


test_input = readdlm("test_input.txt", ',', String, '\n')
bottom = length(test_input)
width = length(test_input[1])
tree_set = parse_map(test_input)
@show count_trees(tree_set, bottom, width, 1, 1)

test_input = readdlm("real_input.txt", ',', String, '\n')
bottom = length(test_input)
width = length(test_input[1])
tree_set = parse_map(test_input)
@show count_trees(tree_set, bottom, width, 1, 1)

# Part 2

tree_set = parse_map(test_input)
tree_hits = Vector{Int}()
for (dr, dc) in [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    push!(tree_hits, count_trees(tree_set, bottom, width, dr, dc))
end
@show tree_hits
@show reduce(*, tree_hits)
