using Test


function make_tree(data)
    num_children = popfirst!(data)
    num_metadata = popfirst!(data)

    child_value_vector = Int[]
    sum_metadata = 0

    for i in 1:num_children
        total, child_value, data = make_tree(data)
        sum_metadata += total
        push!(child_value_vector, child_value)
    end

    sum_metadata += sum(data[1: num_metadata])


    if num_children == 0
        value = sum(data[1: num_metadata])
    else
        value = sum([
            child_value_vector[i] for i in filter(x -> x > 0,
                filter(x -> x <= length(child_value_vector), data[1: num_metadata]))
        ])
    end
    return sum_metadata, value, data[num_metadata + 1: end]
end


test_input = [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]
sum_metadata, value, _ = make_tree(test_input)
@test sum_metadata == 138


string_vector = split(read(open("input.txt", "r"), String))
input_data = map(x -> parse(Int, x), string_vector)
sum_metadata, value, _ = make_tree(input_data)
@show sum_metadata
@show value
