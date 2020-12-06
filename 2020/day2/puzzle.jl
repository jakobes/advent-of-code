using DelimitedFiles
using DataStructures


function count_matches(password)
    counts = DefaultDict{Char, Int}(0)
    for character in password
        counts[character] += 1
    end
    return counts
end


function part1_valid(password, character, lower_bound, upper_bound)
    count_dict = count_matches(password)
    if count_dict[character] > upper_bound
        @show password, "too much"
    elseif count_dict[character] < lower_bound
        @show password, "too little"
    else
        return 1
    end
    return 0
end


function part2_valid(password, character, index1, index2)
    if xor(password[index1] == character, password[index2] == character)
        return 1
    end
    return 0
end


function check_passwords(passwords)
    number_of_valid = 0
    pattern = r"(\d+)-(\d+) (\w): (\w+)"
    for line in passwords
        if !occursin(pattern, line)
            println("Error in parsing passwords")
            return
        end
        m = match(pattern, line)
        lower_bound, upper_bound = map(x->parse(Int, x), [m[1], m[2]])
        character = first(m[3])        # convert to char
        password = m[4]

        number_of_valid += part2_valid(password, character, lower_bound, upper_bound)
    end
    return number_of_valid
end


test_input = readdlm("test_input.txt", ',', String, '\n')
@show test_input
num_valid = check_passwords(test_input)
@show num_valid

test_input = readdlm("real_input.txt", ',', String, '\n')
@show test_input
num_valid = check_passwords(test_input)
@show num_valid
