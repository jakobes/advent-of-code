using DelimitedFiles
using Printf
using Test
using Base.Iterators


function my_push!(input_array::Set{Int}, value::Int)
    if value in input_array
        return false
    end
    push!(input_array, value)
    return true
end


function calibrate(input_array::Array{Int, 1}, maxiter::Int64=Int(1e8))
    seen = Set(0)       # Set has significantly faster look up than array
    current_value = 0
    for (numiter, v) in enumerate(cycle(input_array))
        current_value += v
        if !my_push!(seen, current_value)
            return current_value
        end

        if numiter == maxiter
            break
        end
    end
end


input_array1 = [1, -1]
input_array2 = [3, 3, 4, -2, -4]
input_array3 = [-6, 3, 8, 5, -6]
input_array4 = [7, 7, -2, -7, -4]


@test calibrate(input_array1) == 0
@test calibrate(input_array2) == 10
@test calibrate(input_array3) == 5
@test calibrate(input_array4) == 14


input_array = readdlm("input.txt", ' ', Int, '\n')[:]
println(calibrate(input_array))
