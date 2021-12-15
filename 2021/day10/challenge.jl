function matching_bracket(opening, closing)
    if opening == '(' && closing == ')'
        return true
    elseif opening == '[' && closing == ']'
        return true
    elseif opening == '{' && closing == '}'
        return true
    elseif opening == '<' && closing == '>'
        return true
    end
    return false
end


function compute_score(c)
    if c == ')'
        return 3
    elseif c == ']'
        return 57
    elseif c == '}'
        return 1197
    elseif c == '>'
        return 25137
    end
    return 0
end


function find_corruption(line)
    opened_chunks = []
    closing_set = Set([')', ']', '}', '>'])
    for c in map(only, split(line, ""))
        # @show c
        if c in closing_set
            opening = pop!(opened_chunks)
            matching = matching_bracket(opening, c)
            # @show matching, opening, c
            if !matching
                return compute_score(c)
            end
        else
            push!(opened_chunks, c)
        end
    end
    return opened_chunks
end


function get_matching_bracket(opening)
    if opening == '('
        return ')'
    elseif opening == '['
        return ']'
    elseif opening == '{'
        return '}'
    elseif opening == '<'
        return '>'
    end
    return false
end


function compute_autocomplete_score(closing_seequence)
    score = 0
    for bracket in closing_seequence
        score *= 5
        if bracket == ')'
            score += 1
        elseif bracket == ']'
            score += 2
        elseif bracket == '}'
            score += 3
        elseif bracket == '>'
            score += 4
        end
    end
    return score
end


f = open("input.txt", "r")
scores = Int[]
autocomplete_scores = Int[]
while !eof(f)
    line = readline(f)
    # @show line
    foo = find_corruption(line)
    if typeof(foo) == Int
        push!(scores, foo)
    else
        closing_seequence = reverse(map(get_matching_bracket, foo))
        total_score = compute_autocomplete_score(closing_seequence)
        # @show foo, closing_seequence, total_score
        push!(autocomplete_scores, total_score)
    end
end
@show sum(scores)
sac = sort(autocomplete_scores)
@show sac[length(sac) - div(length(sac), 2)]

close(f)
