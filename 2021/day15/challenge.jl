using DelimitedFiles
using DataStructures


struct Point
    x::Int
    y::Int
end


map_dict = Dict{Point, Int}()
# rows = readdlm("test_input.txt", ' ', String, '\n')
rows = readdlm("input.txt", ' ', String, '\n')
for j = 1:length(rows)
    row = map(x -> parse(Int, x), split(rows[j], ""))
    for i = 1:length(row)
        map_dict[Point(i, j)] = row[i]
    end
end


function expand_map(map_dict; size=10)
    new_map_dict = Dict{Point, Int}()
    for key in keys(map_dict)
        for i = 0:4
            for j = 0:4
                new_value = (map_dict[key] + i + j) % 9
                new_value = new_value == 0 ? 9 : new_value
                new_coordinate = Point(key.x + i*size, key.y + j*size)
                new_map_dict[Point(key.x + i*size, key.y + j*size)] = new_value
            end
        end
    end
    return new_map_dict
end


function get_neighbours(map_dict::Dict{Point, Int}, index)::Set{Point}
    i, j = index.x, index.y
    new_indices = Set{Point}([Point(i + 1, j), Point(i - 1, j), Point(i, j + 1), Point(i, j - 1)])
    valid_indices = keys(map_dict)
    return intersect(new_indices, valid_indices)
end


function find_path(map_dict, start)
    minimal_path = PriorityQueue()
    enqueue!(minimal_path, start, 0)

    risk_dict = Dict{Point, Int}()
    risk_dict[start] = 0

    counter = 0
    max_counter = 500*500
    while !isempty(minimal_path)
        counter += 1
        current = dequeue!(minimal_path)
        current_risk = risk_dict[current]

        neighbours = get_neighbours(map_dict, current)
        valid_neighbours = setdiff(neighbours, keys(risk_dict))
        for neighbour in valid_neighbours
            new_risk = current_risk + map_dict[neighbour]
            enqueue!(minimal_path, neighbour, new_risk)
            risk_dict[neighbour] = new_risk
        end
        println("$counter/$max_counter")
    end
    return risk_dict
end


new_map_dict = expand_map(map_dict, size=100)
# for j = 1:50
#     for i = 1:50
#         print(new_map_dict[Point(i, j)])
#     end
#     println()
# end

start = Point(1, 1)
risk_dict = find_path(new_map_dict, start)
@show risk_dict[Point(500, 500)]
