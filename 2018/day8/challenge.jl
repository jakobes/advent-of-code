using Test


test_input = [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]



function make_tree(test_input)
    if length(test_input) == 0
        return 0
    end

    num_children = popfirst!(test_input)
    num_metadata = popfirst!(test_input)

    if num_children == 0
        cumsum = 0
        for i 1:num_metadata
            cumsum += popfirst!(test_input)
        end
    else
        
    end

    return cumsum
end
