using Test


function get_digits(int::Int)::Array{Int}
    if int >= 10
        return [div(int, 10), mod(int, 10)]
    end
    return [int]
end

@test get_digits(18) == [1, 8]


function mymod(index::Int, recipe_vector::Vector{Int})::Int
    new_index = index + recipe_vector[index] + 1
    if new_index > length(recipe_vector)
        new_index = mod(new_index, length(recipe_vector))
    end
    return new_index
end


function make_hot_chocolate(desired_length)
    recipe_vector = Int[3, 7]
    current_indices =  Int[1, 2]

    while length(recipe_vector) < desired_length + 10
        new_recipes = get_digits(sum(recipe_vector[current_indices]))
        push!(recipe_vector, new_recipes...)
        current_indices = map(x -> mymod(x, recipe_vector), current_indices)
    end
    return recipe_vector
end


# Part 1
target = 846021
foo = make_hot_chocolate(target + 10)
@show foo[target + 1: target + 10]
