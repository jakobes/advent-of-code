using DataStructures


open("input.txt") do f
    global line_dict = Dict{Int, Array{Int, 1}}()
    pattern = r"(\d+)"
    counter = 0
    while !eof(f)
        line = map(x -> parse(Int, x[1]), eachmatch(pattern, readline(f)))
        line_dict[counter] = line
        counter += 1
    end
end


function mark_map(line_dict)
    map_dict = DefaultDict{Array{Int, 1}, Int}(0)
    counter = 0
    for (key, points) in line_dict
        x0, y0, x1, y1 = points

        # Puzzle 1
        horizontal_or_vertical = x0 == x1 || y0 == y1
        if horizontal_or_vertical
            xstep = x0 < x1 ? 1 : -1
            ystep = y0 < y1 ? 1 : -1
            for x = x0:xstep:x1
                for y = y0:ystep:y1
                    map_dict[[x, y]] += 1
                end
            end
        end

        is_diagonal = abs(x0 - x1) == abs(y0 - y1)
        if is_diagonal
            xstep = x0 < x1 ? 1 : -1
            ystep = y0 < y1 ? 1 : -1
            # @show points
            # @show xstep, ystep

            for (new_x, new_y) in zip(x0:xstep:x1, y0:ystep:y1)
                @show new_x, new_y
                map_dict[[new_x, new_y]] += 1
            end
            # println()
        end
        # # Puzzle 2
        # diagonal_down = x0 == y0 && x1 == y1
        # if diagonal_down
        #     @show points
        #     step = x0 < x1 ? 1 : -1
        #     for xy = x0:step:x1
        #         map_dict[[xy, xy]] += 1
        #     end
        #     @show "Diagonal"
        # end

        # diagonal_up = x0 == y1 && x1 == y0
        # if diagonal_up
        #     @show points
        #     xstep = x0 < x1 ? 1 : -1
        #     ystep = y0 < y1 ? 1 : -1
        #     for xy = x0:xstep:x1
        #         new_x = x0 + xstep*xy
        #         new_y = y0 + ystep*xy
        #         map_dict[[new_x, new_y]] += 1
        #     end
        #     @show "Diagonal"
        # end
    end
    return map_dict
end

map_dict = mark_map(line_dict)

for j = 0:9
    for i = 0:9
        val = get(map_dict, [i, j], ".")
        print(val)
    end
    println()
end

map_sum = length(filter(x -> x >= 2, collect(values(map_dict))))
@show map_sum
