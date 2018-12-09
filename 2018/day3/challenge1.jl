using Test
using Base.Iterators


function find_overlap(claim_array, matrix_size::Int)
    fabric_matrix = zeros(Int8, matrix_size, matrix_size)

    for claim in claim_array
        coordinates = collect(eachmatch(r"\d+", claim))[2:end]
        x0, y0, dx, dy = map(x->parse(Int64, x.match), coordinates)
        for i in range(x0, length=dx)
            for j in range(y0, length=dy)
                fabric_matrix[i + 1, j + 1] += 1
            end
        end
    end

    return fabric_matrix
end


claim_array = [
    "#1 @ 1,3: 4x4",
    "#2 @ 3,1: 4x4",
    "#3 @ 5,5: 2x2",
]

overlap_matrix = find_overlap(claim_array, 8)
@test sum(overlap_matrix .== 1) == 28
@test sum(overlap_matrix .>= 2) == 4


input_claims = open("input.txt", "r") do input_file
   input_claims = [line for line in eachline(input_file)]
end

overlap_matrix = find_overlap(input_claims, 1000)
println(sum(overlap_matrix .>= 2))
