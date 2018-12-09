using Test


function check_polarity(c1::Char, c2::Char)
    return xor(islowercase(c1), islowercase(c2))
end


function check_type(c1::Char, c2::Char)
    return lowercase(c1) == lowercase(c2)
end


function are_compatible(c1::Char, c2::Char)
    return check_polarity(c1, c2) && check_type(c1, c2)
end


function chemical_reaction(input::String)
    reagents = Vector{Char}()
    for char in strip(input)
        if length(reagents) > 0 && are_compatible(char, reagents[end])
            pop!(reagents)
        else
            push!(reagents, char)
        end
    end
    return String(reagents)
end


function remove_polymer(input::String, char::Char)
    return filter(x -> !(lowercase(x) == char), input)
end


test = "dabAcCaCBAcCcaDA"

@test check_polarity('A', 'B') == false
@test check_polarity('A', 'b') == true
@test check_polarity('A', 'a') == true
@test check_polarity('a', 'B') == true
@test check_type('a', 'a') == true
@test check_type('A', 'a') == true
@test check_type('a', 'b') == false
@test check_type('B', 'a') == false
@test chemical_reaction(test) == "dabCBAcaDA"
@test remove_polymer(test, 'a') == "dbcCCBcCcD"

input_string = read(open("input.txt", "r"), String)
result = chemical_reaction(input_string)
@show length(result)


# Part 2
function find_min_length(input_string)
    minlength = length(input_string)
    for polymer in range(97, stop=122)
        polymer_soup = remove_polymer(input_string, Char(polymer))
        tmp_length = length(chemical_reaction(polymer_soup))
        if tmp_length < minlength
            minlength = tmp_length
        end
    end
    return minlength
end

minlength = minimum([
    length(chemical_reaction(remove_polymer(input_string, Char(polymer))))
        for polymer in range(97, stop=122)
])
@show minlength
