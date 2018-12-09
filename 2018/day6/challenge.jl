using Test
using DelimitedFiles


function manhattan(x1::Vector{Int}, x2::Vector{Int})
    return sum(map(abs, x1 - x2))
end


function find_closes_point(coordinates::Array{Int, 2}, point::Vector{Int})
    min_distance = Int(1e9)
    closest_coordinate = nothing
    for i in 1:size(coordinates)[1]
        tmp_distance = manhattan(coordinates[i, :], point)
        if tmp_distance < min_distance
            min_distance = tmp_distance
            closest_coordinate = i + 1      # stupid indices start at 1
        elseif tmp_distance == min_distance
            closest_coordinate = -1
        end
    end
    return closest_coordinate
end


function distance_to_all(coordinates::Array{Int, 2}, point::Vector{Int}, threshold::Int)
    distance = sum([manhattan(coordinates[i, :], point) for i in 1:size(coordinates)[1]])
    return distance < threshold ? 1 : -1
end


function fill_in_grid(compute_distance, coordinates::Array{Int, 2})
    xmax, ymax = maximum(coordinates, dims=1)
    xmin, ymin = minimum(coordinates, dims=1)

    grid = zeros(Int, (xmax, ymax))

    for i in 1:size(grid)[1]
        for j in 1:size(grid)[2]
            nearest_point = compute_distance(coordinates, [i, j])
            grid[i, j] = nearest_point
        end
    end

    @assert sum(grid .== 0) == 0

    possible_points = Set(1:length(coordinates))
    for i in 1:xmax - xmin
        delete!(possible_points, grid[i, 1])
        delete!(possible_points, grid[i, end])
    end

    for j in 1:ymax - ymin
        delete!(possible_points, grid[1, j])
        delete!(possible_points, grid[end, j])
    end
    return possible_points, grid
end


coordinates = [
    1 1;
    1 6;
    8 3;
    3 4;
    5 5;
    8 9;
]

points, grid = fill_in_grid(find_closes_point, coordinates)
@test maximum([sum(grid .== p) for p in points]) == 17

input_coordinates = readdlm("input.txt", ',', Int, '\n')

points, grid = fill_in_grid(find_closes_point, input_coordinates)
@show maximum([sum(grid .== p) for p in points])


# Part 2
points, grid = fill_in_grid((x, y) -> distance_to_all(x, y, 32), coordinates)
@test sum(grid .== 1) == 16

points, grid = fill_in_grid((x, y) -> distance_to_all(x, y, 10000), input_coordinates)
@show sum(grid .== 1)
