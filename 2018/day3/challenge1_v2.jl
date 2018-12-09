using Base.Iterators
using Test


function find_overlap(claim_array)
    claim_dict = Dict{Tuple{Int, Int}, Array{Int, 1}}()

    for claim in claim_array
        coordinates = collect(eachmatch(r"\d+", claim))
        claim_id, x0, y0, dx, dy = map(x->parse(Int64, x.match), coordinates)

        for i in range(x0, length=dx)
            for j in range(y0, length=dy)
                index = (i, j)
                if haskey(claim_dict, index)
                    push!(get(claim_dict, index, []), claim_id)
                else
                    claim_dict[index] = [claim_id]
                end
            end
        end
    end

    return claim_dict
end


claim_array = [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2",
]


claim_dict = find_overlap(claim_array)
@test sum([length(val) == 1 for val in values(claim_dict)]) == 28
@test sum([length(val) == 2 for val in values(claim_dict)]) == 4


input_claims = open("input.txt", "r") do input_file
   input_claims = [line for line in eachline(input_file)]
end

claim_dict = find_overlap(input_claims)
println(sum([length(val) >= 2 for val in values(claim_dict)]))
