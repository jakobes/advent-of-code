include("LinkedLists.jl")
using .LinkedLists

struct PolymerIndex{T}
    index::AbstractNode{T}
    value::Char
end
PolymerIndex(i::T, c) where T = PolymerIndex{T}(i, c)


f = open("test_input.txt", "r")
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

ll_template = LinkedList{Char}()
prepend!(ll_template, template)


function compute_insertions(template, rule_dict)
    last_index = lastindex(template)

    insert_list = Array{PolymerIndex, 1}()
    rules = keys(rule_dict)
    for index in keys(template)
        if index == last_index
            break
        end
        item = getindex(template, index)
        nextitem = getindex(template, index.next)

        char_pair = [item, nextitem]
        if char_pair in rules
            polymer_index = PolymerIndex(index.next, rule_dict[char_pair])
            push!(insert_list, polymer_index)
        end
    end

    for polymer_index in insert_list
        insert!(template, polymer_index.index, polymer_index.value)
    end
end

for i = 1:40
    @show i
    compute_insertions(ll_template, rule_dict)
    # print(ll_template)
    println()
end
@show length(ll_template)
count_dict = Dict(key => count(x -> x == key, ll_template) for key in unique(ll_template))
counts = values(count_dict)
@show count_dict
@show maximum(counts) - minimum(counts)





# for i = 1:16
#     @show i
#     compute_insertions(template, rule_dict)
#     # @time compute_insertions(template, rule_dict)
#     println()
# end
# @show length(template)
# count_dict = Dict(key => count(x -> x == key, template) for key in unique(template))
# @show count_dict
# counts = values(count_dict)
# @show maximum(counts) - minimum(counts)



