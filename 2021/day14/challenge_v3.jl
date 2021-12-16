using DataStructures

f = open("input.txt", "r")
template = map(only, split(readline(f), ""))
pair_dict = DefaultDict{Array{Char, 1}, Int}(0)

for i = 1:length(template) - 1
    pair_dict[template[i:i + 1]] += 1
end

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


function update_pairs(pair_dict, count_dict, rule_dict)
    new_pair_dict = DefaultDict{Array{Char, 1}, Int}(0)
    for ((first_char, second_char), value) in pair_dict
        new_char = rule_dict[[first_char, second_char]]
        new_pair_dict[[first_char, new_char]] += value
        new_pair_dict[[new_char, second_char]] += value
        count_dict[new_char] += value
    end
    return new_pair_dict, count_dict
end


count_dict = DefaultDict{Char, Int}(0)
for c in template
    count_dict[c] += 1
end


for i = 1:40
    global pair_dict, count_dict = update_pairs(pair_dict, count_dict, rule_dict)
    @show count_dict
end

@show maximum(values(count_dict)) - minimum(values(count_dict))
