using DelimitedFiles
using Test


function find_match(string_array)
    match = nothing
    for i in range(1, length=length(string_array))
        for j in range(i + 1, stop=length(string_array))
            idx = string_array[i] .== string_array[j]       # boolean array
            if sum(.!idx) == 1
                match = string_array[i][idx]
            end
        end
    end
    return match
end


string_array = [
    "abcde"
    "fghij"
    "klmno"
    "pqrst"
    "fguij"
    "axcye"
    "wvxyz"
]

@test String(find_match(map(codeunits, string_array))) == "fgij"


my_array = map(codeunits, readdlm("input.txt", ' ', String, '\n'))[:]
match = String(find_match(my_array))
println(match)
