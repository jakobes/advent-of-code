using DelimitedFiles
using Test


function count_depth(depth_array)
    depth_count = 0
    for i = 2:length(depth_array)
        if depth_array[i] > depth_array[i - 1]
            depth_count += 1
        end
    end
    return depth_count
end


function sliding_depth_count(depth_array)
    depth_count = 0

    prev_sum = 0
    for i = 1:length(depth_array) - 2
        current_sum = 0
        for j = 0:2
            current_sum += depth_array[i + j]
        end
        if current_sum > prev_sum && prev_sum != 0
            depth_count += 1
        end
        prev_sum = current_sum
    end
    return depth_count
end


test_input_array = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
test_count = count_depth(test_input_array)
@test test_count == 7

real_depth = readdlm("input1.txt", ' ', Int, '\n')[:]
real_count = count_depth(real_depth)
@show real_count

test_sliding_count = sliding_depth_count(test_input_array)
@test test_sliding_count == 5

real_sliding_count = sliding_depth_count(real_depth)
@show real_sliding_count
