using Base.Iterators
using Test


function find_overlap(claim_array)
    index_dict = Dict{Tuple{Int, Int}, Int}()
    claim_dict = Dict{Int, Tuple{Int, Int, Int, Int}}()

    for claim in claim_array
        coordinates = collect(eachmatch(r"\d+", claim))
        claim_id, x0, y0, dx, dy = map(x->parse(Int64, x.match), coordinates)
        claim_dict[claim_id] = (x0, y0, dx, dy)

        for i in range(x0, length=dx)
            for j in range(y0, length=dy)
                index = (i, j)
                index_dict[index] = get(index_dict, index, 0) + 1
            end
        end
    end

    good_claim_set = Set{Int}()
    for claim_id in keys(claim_dict)
        good_claim = true
        x0, y0, dx, dy = claim_dict[claim_id]
        for i in range(x0, length=dx)
            for j in range(y0, length=dy)
                if index_dict[i, j] > 1
                    good_claim = false
                end
            end
        end
        if good_claim
            push!(good_claim_set, claim_id)
        end
    end
    return good_claim_set
end


claim_array = [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2",
]


good_claims = find_overlap(claim_array)
@test find_overlap(claim_array) == Set(3)
# println(good_claims)

input_claims = open("input.txt", "r") do input_file
   input_claims = [line for line in eachline(input_file)]
end

good_claims = find_overlap(input_claims)
println(good_claims)
