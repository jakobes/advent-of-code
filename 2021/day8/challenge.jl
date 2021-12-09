using Test
using DataStructures


function find_uniques(line_array)
    num_uniques = 0
    for i = 1:length(line_array)
        line = line_array[i]
        digits = filter(x -> length(x) > 0, split(line, " "))
        foo = filter(x -> length(x) in [2, 3, 4, 7], digits)
        num_uniques += length(foo)
    end
    return num_uniques
end


function compute_frequency_dict(input_line, output_line)
    line_dict = Dict()
    input_digits = filter(x -> length(x) > 0, split(input_line, " "))

    for j = 1:length(input_digits)
        digit = input_digits[j]
        digit_length = length(digit)

        digit_array = get(line_dict, digit_length, Any[])
        line_dict[digit_length] = push!(digit_array, Set(map(only, split(digit, ""))))
    end

    output_digits = filter(x -> length(x) > 0, split(output_line, " "))
    for j = 1:length(output_digits)
        digit = output_digits[j]
        digit_length = length(digit)

        digit_array = get(line_dict, digit_length, Any[])
        line_dict[digit_length] = push!(digit_array, Set(map(only, split(digit, ""))))
    end

    # make unique
    for (k, v) in line_dict
        line_dict[k] = unique(line_dict[k])
    end

    return line_dict
end


function find_digit(digits, set1, set2, frequency)
    frequencies = DefaultDict(0)
    for i = 1:length(digits)
        dset = setdiff(setdiff(digits[i], set1), set2)
        # @show dset
        for char in dset
            frequencies[char] += 1
        end
    end

    # @show frequencies
    keys = [k for (k, v) in frequencies if v == 2]
    @test length(keys) == 1
    return keys[1]
end


function compute_mapping(frequency_dict)
    seven = frequency_dict[3][1]
    one = frequency_dict[2][1]
    four = frequency_dict[4][1]
    eight = frequency_dict[7][1]
    mapping = Dict()
    mapping["a"] = collect(setdiff(seven, one))[1]

    bd_set = setdiff(four, one)
    eg_set = setdiff(eight, union(seven, four))

    mapping["d"] = find_digit(frequency_dict[6], eg_set, one, 2)
    mapping["b"] = filter(x -> x != mapping["d"], collect(bd_set))[1]
    mapping["e"] = find_digit(frequency_dict[6], one, Set(mapping["d"]), 2)
    mapping["g"] = filter(x -> x != mapping["e"], collect(eg_set))[1]
    mapping["c"] = find_digit(frequency_dict[6], Set(mapping["d"]), Set(mapping["e"]), 2)
    mapping["f"] = filter(x -> x != mapping["c"], collect(one))[1]

    # invert dict
    inverted_map = Dict(v => k for (k, v) in mapping)
    return inverted_map
end


function set_to_int(digit_set, mapping)
    correct_set = Set([mapping[d] for d in map(only, split(digit_set, ""))])

    if correct_set == Set(["a", "b", "c", "e", "f", "g"])
        return 0
    elseif correct_set == Set(["c", "f"])
        return 1
    elseif correct_set == Set(["a", "c", "d", "e", "g"])
        return 2
    elseif correct_set == Set(["a", "c", "d", "f", "g"])
        return 3
    elseif correct_set == Set(["b", "d", "c", "f"])
        return 4
    elseif correct_set == Set(["a", "b", "d", "f", "g"])
        return 5
    elseif correct_set == Set(["a", "b", "d", "e", "f", "g"])
        return 6
    elseif correct_set == Set(["a", "c", "f"])
        return 7
    elseif correct_set == Set(["a", "b", "c", "d", "e", "f", "g"])
        return 8
    elseif correct_set == Set(["a", "b", "c", "d", "f", "g"])
        return 9
    else
        throw(ErrorException("No mathing digit set"))
    end
end


function oline_to_digit(oline, mapping)
    digits = Int[]
    for d in filter(x -> length(x) > 0, split(oline, " "))
        dint = set_to_int(d, mapping)
        push!(digits, dint)
    end
    integer = 0
    for i = 1:length(digits)
        integer += digits[end - (i - 1)]*10^(i - 1)
    end
    return integer
end


open("input.txt", "r") do f
    global input_array = Any[]
    global output_array = Any[]

    while !eof(f)
        input, output = split(readline(f), "|")
        push!(input_array, input)
        push!(output_array, output)
    end
end

# num_uniques = find_uniques(output_array)
# @show num_uniques

function f()
    iline = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab"
    oline = "cdfeb fcadb cdfeb cdbaf"
    frequency_dict = compute_frequency_dict(iline, oline)
    mapping = compute_mapping(frequency_dict)
    test_int = oline_to_digit(oline, mapping)
    @test test_int == 5353
end


function part2(input_array, output_array)
    counter = 0
    for (iline, oline) in zip(input_array, output_array)
        frequency_dict = compute_frequency_dict(iline, oline)
        mapping = compute_mapping(frequency_dict)
        myint = oline_to_digit(oline, mapping)
        counter += myint
    end
    @show counter
end
part2(input_array, output_array)
