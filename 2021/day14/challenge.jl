struct PolymerIndex
    index::Int
    value::Char
end


f = open("input.txt", "r")
template = map(only, split(readline(f), ""))

# skip blank line
readline(f)

rule_dict = Dict{Array{Char, 1}, Char}()
pattern = r"([A-Z]+).*([A-Z])"
while !eof(f)
    line = readline(f)
    matches = match(pattern, line)
    rule_dict[map(only, split(matches.captures[1], ""))] = only(matches.captures[2])
end
close(f)


function compute_insertions(template, rule_dict)
    insert_list = Array{PolymerIndex, 1}()
    @time @inbounds for i  = 1:length(template) - 1
        pair = template[i:i+1]
        if pair in keys(rule_dict)
            push!(insert_list, PolymerIndex(i + 1, rule_dict[pair]))
        end
    end

    offset = 0
    @time @inbounds for polymer_index in insert_list
        insert!(template, polymer_index.index + offset, polymer_index.value)
        offset += 1
    end
end


for i = 1:16
    @show i
    compute_insertions(template, rule_dict)
    # @time compute_insertions(template, rule_dict)
    println()
end
@show length(template)
count_dict = Dict(key => count(x -> x == key, template) for key in unique(template))
@show count_dict
counts = values(count_dict)
@show maximum(counts) - minimum(counts)



