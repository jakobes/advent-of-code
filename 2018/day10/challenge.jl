using DelimitedFiles
using IterTools
using Printf


function display_grid(grid::Array{Int, 2})
    for j in 1:size(grid)[2]
        for i in 1:size(grid)[1]
            @printf("%c ", grid[i, j])
        end
        println()
    end
end


function read_input(filename::String)::Matrix{Int}
    signal_vector = Array{Int64, 2}[]

    for e in readdlm(filename, '\n', String, '\n')
        x0, y0, vx, vy = map(x -> parse(Int, x.match), collect(eachmatch(r"-?\d+", e)))
        push!(signal_vector, [x0 y0 vx vy])
    end
    return vcat(signal_vector...)
end


function find_minimum(data::Matrix{Int}, maxiter::Int)::Tuple{Int, Int, Int}
    size_vector = Tuple{Int, Int}[]
    for t in 0:maxiter
        points = [(x + t*vx, y + t*vy) for (x, y, vx, vy) in partition(data', 4)]
        xmin, xmax = extrema(map(x -> x[1], points))
        ymin, ymax = extrema(map(x -> x[2], points))

        push!(size_vector, (xmax - xmin, ymax - ymin))
    end

    value, index = findmin(map(x -> sum(x), size_vector))
    return index, size_vector[index][1], size_vector[index][2]
end


function play(data, xsize, ysize, play_start, play_stop)
    grid = zeros(Int, 300, 300)
    for t in play_start:play_stop
        fill!(grid, '.')
        for i in 1:size(data)[1]
            x, y, vx, vy = data[i, :]
            # @show x, y, vx, vy
            grid[xsize + x + t*vx + 1, ysize + y + t*vy + 1] = '#'
        end
        display_grid(grid)
        readline(stdin)
    end
end


data = read_input("test_input.txt")
index, xsize, ysize = find_minimum(data, 10)
# play(data, xsize, ysize, 2, 5)

data = read_input("input.txt")
# index, xsize, ysize = find_minimum(data, 100000)
# @show index, xsize, ysize
play(data, xsize, ysize, 10830, 10835)
