using Test

test_instructions = ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]


function calculate_position(instructions)
    position = [0, 0]

    for i = 1:length(instructions)
        direction, delta_string = split(instructions[i], " ")
        delta = parse(Int64, delta_string)

        if direction == "forward"
            position[1] += delta
        elseif direction == "up"
            position[2] -= delta
        elseif direction == "down"
            position[2] += delta
        else
            error("Unknown direction: $direction")
        end
    end
    return position
end


function calculate_position_aim(instructions)
    position = [0, 0]
    aim = 0

    for i = 1:length(instructions)
        direction, delta_string = split(instructions[i], " ")
        delta = parse(Int64, delta_string)

        if direction == "forward"
            position[1] += delta
            position[2] += aim*delta
        elseif direction == "up"
            aim -= delta
        elseif direction == "down"
            aim += delta
        else
            error("Unknown direction: $direction")
        end
    end
    return position
end


test_position = calculate_position(test_instructions)
@test test_position[1]*test_position[2] == 150

test_aim_position = calculate_position_aim(test_instructions)
@test test_aim_position[1]*test_aim_position[2] == 900

open("input.txt", "r") do file_stream
    real_instructions = readlines(file_stream)
    real_position = calculate_position(real_instructions)
    @show real_position[1]*real_position[2]

    real_aim_position = calculate_position_aim(real_instructions)
    @show real_aim_position[1]*real_aim_position[2]
end

