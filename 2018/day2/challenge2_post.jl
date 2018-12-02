using DelimitedFiles
using Test


function find_match(string_array)
    substitution_set = Set{String}()
    for row in string_array
        for i in range(1, length=length(row))
            new_row = String(vcat(row[1:i - 1], [0x5f], row[i+1:end]))
            if new_row in substitution_set
                return vcat(row[1:i-1], row[i+1:end])
            end
            push!(substitution_set, new_row)
        end
    end
end


string_array = map(codeunits, [
    "abcde"
    "fghij"
    "klmno"
    "pqrst"
    "fguij"
    "axcye"
    "wvxyz"
])
@test String(find_match(string_array)) == "fgij"


my_array = map(codeunits, readdlm("input.txt", ' ', String, '\n'))[:]
match = String(find_match(my_array))
println(match)
