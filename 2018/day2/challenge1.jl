using DelimitedFiles
using Test
using Base.Iterators


function countmap(input_array)
    cm = Dict()
    for v in input_array
        cm[v] = get(cm, v, 0) + 1
    end
    return map(Int, [2 in values(cm), 3 in values(cm)])
end


input_str1 = "abcdef"
input_str2 = "bababc"
input_str3 = "abbcde"
input_str4 = "abcccd"
input_str5 = "aabcdd"
input_str6 = "abcdee"
input_str7 = "ababab"


@test countmap(input_str1) == [0, 0]
@test countmap(input_str2) == [1, 1]
@test countmap(input_str3) == [1, 0]
@test countmap(input_str4) == [0, 1]
@test countmap(input_str5) == [1, 0]
@test countmap(input_str6) == [1, 0]
@test countmap(input_str7) == [0, 1]


my_array = readdlm("input.txt", ' ', String, '\n')
checksum = reduce(*, sum(countmap(line) for line in my_array))
println(checksum)
