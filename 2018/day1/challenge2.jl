using DelimitedFiles
using Printf
using Test


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


function calibrate(input_array::Array{Int, 1}, maxiter::Int64=Int(1e8))
    fstate = FrequencyState(0, [0])
    for (numiter, v) in enumerate(Iterators.cycle(input_array))
        # global fstate
        success, fstate = find_first_duplicate(fstate, v)

        if success
            return fstate.current_state
        end

        if numiter == maxiter
            break
        end
    end
end


input_array1 = [1, -1]
input_array2 = [3, 3, 4, -2, -4]
input_array3 = [-6, 3, 8, 5, -6]
input_array4 = [7, 7, -2, -7, -4]


@test calibrate(input_array1) == 0
@test calibrate(input_array2) == 10
@test calibrate(input_array3) == 5
@test calibrate(input_array4) == 14


# Evaluate on real input
input_array = readdlm("input.txt", ' ', Int, '\n')
foo = calibrate(input_array[:])
println(foo)
