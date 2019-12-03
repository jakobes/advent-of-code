using DelimitedFiles

function instruction_to_path(instruction)
    direction_keyword = instruction[1]
    magnitude = parse(Int, instruction[2:end])

    direction_dict = Dict(
        'U' => 1im,
        'D' => -1im,
        'R' => 1,
        'L' => -1
    )

    direction = direction_dict[direction_keyword]
    return direction, magnitude
end


function build_wire_path(instruction_array)
    position = 0 + 0im
    path_dict = Dict()
    time = 0

    for instruction in instruction_array
        direction, magnitude = instruction_to_path(instruction)

        for _ in 1:magnitude
            time += 1
            position += direction
            if !haskey(path_dict, position)
                path_dict[position] = time
            end
        end
    end

    return path_dict
end


function manhattan_magnitude(number::Complex)
    return abs(number.re) + abs(number.im)
end


# path1 = build_wire_path(["U2", "L3", "D4", "R6", "U6", "L10", "D5", "R5", "D3"])
# path2 = build_wire_path(["R4", "D5", "L9", "U10", "R4", "D4"])
# 
# intersection = intersect!(Set(keys(path1)), Set(keys(path2)))
# @show intersection
# 
# min_distance = minimum([manhattan_magnitude(x) for x in intersection])
# @show min_distance


# path1 = build_wire_path(["R8", "U5", "L5", "D3"])
# path2 = build_wire_path(["U7", "R6", "D4", "L4"])
#
# intersection = intersect!(path1, path2)
# @show intersection
#
# min_distance = minimum([manhattan_magnitude(x) for x in intersection])
# @show min_distance

# path1 = build_wire_path(["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"])
# path2 = build_wire_path(["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"])
# 
# intersection = intersect!(path1, path2)
# @show intersection
# 
# distances = [manhattan_magnitude(x) for x in intersection]
# @show distances, minimum(distances)
# 
# path1 = build_wire_path(["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"])
# path2 = build_wire_path(["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"])
# 
# intersection = intersect!(path1, path2)
# @show intersection
# 
# distances = [manhattan_magnitude(x) for x in intersection]
# @show distances, minimum(distances)


challenge_input1 = readdlm("input1.txt", '\n', String, '\n')[:]
path1 = build_wire_path(split(challenge_input1[1], c -> c == ','))
path2 = build_wire_path(split(challenge_input1[2], c -> c == ','))

intersection = intersect!(Set(keys(path1)), Set(keys(path2)))
@show intersection

distances = [manhattan_magnitude(x) for x in intersection]
@show minimum(distances)

f00 = minimum([path1[k] + path2[k] for k in intersection])
@show f00


