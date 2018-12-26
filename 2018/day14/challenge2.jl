using Test


function mymod(index::Int, score::String)::Int
    new_index = index + parse(Int, score[index]) + 1
    if new_index > length(score)
        new_index = mod(new_index, length(score))
    end
    return new_index
end


function string_compare(scores, target, len)
    length(scores) > len || return false
    for (i, score_char) in enumerate(scores[end - len: end])
        score_char == target[i] || return false
    end
    return true
end


function make_chocolate(recipe::String)
    scores = "37"
    elf1 = 1
    elf2 = 2

    while !string_compare(scores, recipe, length(recipe) - 1)
        scores *= string(parse(Int, scores[elf1]) + parse(Int, scores[elf2]))
        elf1 = mymod(elf1, scores)
        elf2 = mymod(elf2, scores)
    end
    return length(scores) - length(recipe)
end


@test make_chocolate("51589") == 9
@test make_chocolate("01245") == 5
@test make_chocolate("92510") == 18
@test make_chocolate("59414") == 2018
