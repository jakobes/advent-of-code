using DelimitedFiles


function fix_account(account, start_value=0)
    for i = 1:length(account)
        for j = i:length(account)
            if start_value + account[i] + account[j] == 2020
                return i, j
            end
        end
    end
    return 0, 0
end


test_data = [1721, 979, 366, 299, 675, 1456]
i, j = fix_account(test_data)
@show test_data[i] * test_data[j]

puzzle_input = readdlm("test_input.txt", ',', Int, '\n')[:]
i, j = fix_account(puzzle_input)
@show puzzle_input[i] * puzzle_input[j]

# Part Two
function fix_extended_account(account)
    for k in 1:length(account)
        i, j = fix_account(account, account[k])
        if i != 0 && j != 0
            return i, j, k
        end
    end
    return 0, 0, 0
end

i, j, k = fix_extended_account(test_data)
@show test_data[i] * test_data[j] * test_data[k]

i, j, k = fix_extended_account(puzzle_input)
@show puzzle_input[i] * puzzle_input[j] * puzzle_input[k]
