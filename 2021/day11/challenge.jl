using DelimitedFiles


function create_octopus_map(rows)
    octo_map = Dict{Array{Int, 1}, Int}()
    for i = 1:length(rows)
        row = map(x -> parse(Int, x), split(rows[i], ""))
        for j = 1:length(row)
            octo_map[[i, j]] = row[j]
        end
    end
    return octo_map
end


function print_map(octo_map)
    for i = 1:10
        for j = 1:10
            print(octo_map[[i, j]])
        end
        println()
    end

end


function get_neighbours(octo_map, index)
    i, j = index
    neighbors = Set{Array{Int, 1}}()
    push!(neighbors, [i - 1, j - 1])
    push!(neighbors, [i, j - 1])
    push!(neighbors, [i + 1, j - 1]) 
    push!(neighbors, [i + 1, j])
    push!(neighbors, [i - 1, j])

    push!(neighbors, [i - 1, j + 1])
    push!(neighbors, [i, j + 1])
    push!(neighbors, [i + 1, j + 1])

    valid_neighbors = intersect(neighbors, Set(keys(octo_map)))
end


function keep_flashing(index, octo_map, has_flashed)
    neighbours = get_neighbours(octo_map, index)
    for neighbour_index in neighbours
        octo_map[neighbour_index] += 1

        if octo_map[neighbour_index] > 9 && !(neighbour_index in has_flashed)
        # if octo_map[neighbour_index] > 9
            push!(has_flashed, neighbour_index)
            keep_flashing(neighbour_index, octo_map, has_flashed)
        end
    end
end


function simulate_octopi(octo_map)
    flash_counter = 0
    for counter = 1:1000
        has_flashed = Set{Array{Int, 1}}()

        for index in keys(octo_map)
            octo_map[index] += 1
            if octo_map[index] > 9 && !(index in has_flashed)
                push!(has_flashed, index)
                keep_flashing(index, octo_map, has_flashed)
            end
        end
        flash_counter += length(has_flashed)

        for index in has_flashed
            octo_map[index] = 0
        end

        if length(has_flashed) == 100
            @show "Synchronized at step $counter"
        end
    end
    return flash_counter
end


rows = readdlm("input.txt", ' ', String, '\n')
octo_map = create_octopus_map(rows)

flash_counter = simulate_octopi(octo_map)

print_map(octo_map)
@show flash_counter

# get_neighbours(octo_map, [1, 1])
