using DelimitedFiles
using Test


function calibrate(input_array::Array{Int64, 1})
    return sum(input_array)
end


input_array1 = [1, 1, 1]
input_array2 = [1, 1, -2]
input_array3 = [-1, -2, -3]


@test calibrate(input_array1) == 3
@test calibrate(input_array2) == 0
@test calibrate(input_array3) == -6


my_array = readdlm("input.txt", ' ', Int, '\n')[:]
println(calibrate(my_array))
