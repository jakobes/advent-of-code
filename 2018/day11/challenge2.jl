using DataStructures
using Test


function compute_power_level(xc::Int, yc::Int, serial_number::Int)::Int
    id = xc + 10
    power_level = (id*yc + serial_number)*id
    pl = parse(Int, string(power_level)[end - 2]) - 5       # mod is probably faster
    return pl
end


function compute_grid(xstart::Int, ystart::Int, len::Int, serial_number::Int)::Matrix{Int}
    grid = zeros(Int, len, len)
    for I in CartesianIndices(grid)
        grid[I] = compute_power_level(
            (I.I .+ (xstart - 1, ystart - 1))...,
            serial_number
        )
    end
    return grid
end


function accumulate_power(grid::Matrix{Int}, gs_vector=[3])
    scores = DefaultDict{Tuple{Int, Int, Int}, Int}(0)
    grid_size = size(grid)
    for n in gs_vector
        @show n
        for I in CartesianIndices((1:grid_size[1] - (n - 1), 1:grid_size[2] - (n - 1)))
            x, y = I.I
            scores[x, y, n] += sum(grid[x: x + (n - 1), y: y + (n - 1)])
        end
    end
    key = reduce((x, y) -> scores[x] >= scores[y] ? x : y, keys(scores))
    return key..., scores[key]
end


@assert compute_power_level(122, 79, 57) == -5
@assert compute_power_level(217, 196, 39) == 0
@assert compute_power_level(101, 153, 71) == 4

grid = compute_grid(32, 44, 5, 18)
@test accumulate_power(grid)[end] == 29

grid = compute_grid(20, 60, 5, 42)
@test accumulate_power(grid)[end] == 30

# Task 1
grid = compute_grid(1, 1, 300, 7672)
foo = accumulate_power(grid)
@show foo

# # Task 2
# grid = compute_grid(1, 1, 300, 7672)
# foo = accumulate_power(grid, 1:300)
# @show foo
