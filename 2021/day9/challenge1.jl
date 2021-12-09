using DelimitedFiles


function create_height_map(rows)
    height_map = Dict{Array{Int, 1}, Int}()
    xlength = length(rows[1])
    ylength = length(rows)
    for j = 1:ylength
        row = map(x -> parse(Int, x), collect(rows[j]))
        for i = 1:xlength
            height_map[[i, j]] = row[i]
        end
    end
    return height_map, xlength, ylength
end


function find_local_minima(height_map, xlength, ylength)
    local_minima = Set{Array{Int, 1}}()
    for (i, j) in keys(height_map)
        above = get(height_map, [i, j - 1], 666)
        below = get(height_map, [i, j + 1], 666)
        left = get(height_map, [i - 1, j], 666)
        right = get(height_map, [i + 1, j], 666)
        current_height = height_map[[i, j]]
        isminimum = all(map(x -> current_height < x, [above, below, left, right]))

        if isminimum
            push!(local_minima, [i, j])
        end
    end
    return local_minima
end


function print_map(height_map, xlength, ylength)
    for j = 1:ylength
        for i = 1:xlength
            print(height_map[[i, j]])
        end
        println()
    end
end


rows = readdlm("input.txt", ' ', String, '\n')[:]
height_map, xlength, ylength = create_height_map(rows)
# print_map(height_map, xlength, ylength)
local_minima = find_local_minima(height_map, xlength, ylength)
# @show local_minima

risk_value = sum([height_map[index] + 1 for index in local_minima])
# @show risk_value

# Part 2
function get_neighbours(index, basin, height_map)
    # neighbour_set = Set{Array{Int, 1}}()
    i, j = index
    new_indices = Set([[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]])
    valid_indices = keys(height_map)
    new_valid_indices = setdiff(intersect(new_indices, valid_indices), basin)
    return new_valid_indices
end


function add_to_basin(point, basin, height_map)
    push!(basin, point)
    neighbours = get_neighbours(point, basin, height_map)
    current_height = height_map[point]
    for n in neighbours
        if current_height < height_map[n] && height_map[n] != 9
            add_to_basin(n, basin, height_map)
        end
    end
end


function find_basin_sizes(height_map, local_minima)
    basin_sizes = []
    for local_minimum in local_minima
        basin = Set{Array{Int, 1}}()
        add_to_basin(local_minimum, basin, height_map)
        push!(basin_sizes, length(basin))
    end
    return basin_sizes
end


size_array = find_basin_sizes(height_map, local_minima)
three_largest = sort(size_array, rev=true)[1:3]
@show reduce(*, three_largest)
