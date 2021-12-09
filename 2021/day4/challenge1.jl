function check_rows(board::Array{Array{Int, 1}, 1}, number::Int)::Bool
    for i = 1:5
        marked_count = 0
        for j = 1:5
            if board[i][j] == number
                board[i][j] = -1
            end

            if board[i][j] == -1
                marked_count += 1
                if marked_count == 5
                    return true
                end
            end
        end
    end
    return false
end


function compute_sum(board::Array{Array{Int, 1}, 1})::Int
    row_sum = 0
    for i = 1:5
        row_sum += sum(filter(x -> x != -1, board[i]))
    end
    return row_sum
end


function check_columns(board::Array{Array{Int, 1}, 1}, number::Int)::Bool
    for i = 1:5
        marked_count = 0
        for j = 1:5
            if board[j][i] == number
                board[j][i] = -1
            end

            if board[j][i] == -1
                marked_count += 1
                if marked_count == 5
                    return true
                end
            end
        end
    end
    return false
end


open("input.txt") do f
# open("test_input.txt") do f
    global number_list = map(x -> parse(Int, x), split(readline(f), ","))
    global board_dict = Dict{Int, Array{Array{Int, 1}, 1}}()

    counter = 1
    while !eof(f)
        board_row = Array{Array{Int, 1}, 1}()
        foo = readline(f)   # skip blank line
        for i = 1:5
            row = readline(f)
            push!(board_row, map(x -> parse(Int, x), filter(x -> length(x) > 0, split(row, " "))))
        end
        board_dict[counter] = board_row
        counter += 1
    end
end


function play_game(board_dict, number_list; task=1)
    counter = 0
    for number in collect(number_list)
        row_complete = false
        column_complete = false

        for (board_id, board) in board_dict
            row_complete = check_rows(board, number)
            column_complete = check_columns(board, number)
            if row_complete || column_complete
                println("Board $board_id complete")
                if task == 1
                    return board, number
                elseif task == 2
                    if length(board_dict) == 1
                        return board, number
                    end
                    delete!(board_dict, board_id)
                end
            end
        end

        # counter += 1
        # if counter == 12
        #     for i = 1:3
        #         for j = 1:5
        #             @show board_list[i][j]
        #         end
        #         println()
        #     end
        #     return
        # end
    end
end


winning_board, winning_number = play_game(board_dict, number_list; task=2)
board_score = compute_sum(winning_board)
@show winning_board, board_score*winning_number
