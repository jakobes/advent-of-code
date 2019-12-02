using DelimitedFiles
using Test


function intcode(oparray)
    i = 1
    while true     # Check index later
        opcode = oparray[i]

        if opcode == 1
            value1 = oparray[oparray[i + 1] + 1]
            value2 = oparray[oparray[i + 2] + 1]
            result = value1 + value2
        elseif opcode == 2
            value1 = oparray[oparray[i + 1] + 1]
            value2 = oparray[oparray[i + 2] + 1]
            result = value1*value2
        elseif opcode == 99
            return oparray
        else
            return [-1]
        end
        index = oparray[i + 3]
        oparray[index + 1] = result
        i += 4
    end
    return oparray
end


test1 = intcode([1, 0, 0, 0, 99])
@show(test1)

test2 = intcode([2, 3, 0, 3, 99])
@show test2

test4 = intcode([2, 4, 4, 5, 99, 0])
@show test4

test5 = intcode([1, 1, 1, 4, 99, 5, 6, 0, 99])
@show test5


function compute_value(noun, verb, instructions)
    instructions[1 + 1] = noun
    instructions[1 + 2] = verb
    return intcode(instructions)
end


challenge_input1 = readdlm("test_input1.txt", ',', Int, '\n')[:]
# answer1 = compute_value(12, 2, challenge_input1)
# @show challenge_input1[1]

# answer1 = compute_value(64, 29, challenge_input1)
# @show challenge_input1[1]


function brute_force()
    for verb in 0: 100
        for noun in 0:100
            answer = compute_value(verb, noun, copy(challenge_input1))[1]
            if answer == 19690720
                @show answer, verb, noun
                return
            end
        end
    end
end

brute_force()
