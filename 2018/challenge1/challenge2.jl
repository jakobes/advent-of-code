using DelimitedFiles
using Printf

input_array = readdlm("input.txt", ' ', Int, '\n')
input_array1 = [1, -1]              # 0
input_array2 = [3, 3, 4, -2, -4]    # 10
input_array3 = [-6, 3, 8, 5, -6]    # 5
input_array4 = [7, 7, -2, -7, -4]    # 14


mutable struct FrequencyState
    current_state::Int
    unique_states::Array{Int, 1}
end


function find_first_duplicate(state::FrequencyState, input_frequency::Int)
    # Update current state
    current_state = state.current_state + input_frequency

    retval = false
    if (current_state in state.unique_states)
        retval = true
    end

    # Update list of previous states
    push!(state.unique_states, current_state)
    return (retval, FrequencyState(current_state, state.unique_states))
end


fstate = FrequencyState(0, [0])
for (numiter, v) in enumerate(Iterators.cycle(input_array))
    global fstate
    a, fstate = find_first_duplicate(fstate, v)

    if a
        println(fstate.current_state)
        @printf("Success after %d iterations!", numiter)
        break
    end

    if numiter == Int(1e8)
        @printf("Failure after %d iterations!", numiter)
        break
    end
end
