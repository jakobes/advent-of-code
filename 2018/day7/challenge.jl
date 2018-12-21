using Test


function create_task_dict(input)::Dict{Char, Set{Char}}
    task_dict = Dict{Char, Set{Char}}()
    for line in split(strip(input), '\n')
        task, dependant = map(
            x -> line[x.match.offset + 1], collect(eachmatch(r"[A-Z]", line))[2:end]
        )
        task_dict[task] = get(task_dict, task, Set{Char}())
        task_dict[dependant] = push!(get(task_dict, dependant, Set{Char}()), task)
    end
    return task_dict
end


function get_next_task!(task_dict::Dict{Char, Set{Char}})::Char
    next_tasks = Char[]
    for key in keys(task_dict)
        if length(task_dict[key]) == 0
            push!(next_tasks, key)
        end
    end

    if length(next_tasks) > 0
        sort!(next_tasks)
        pop!(task_dict, next_tasks[1])
        return next_tasks[1]
    end
    return next_tasks
end


function update_task_dict!(task_dict::Dict{Char, Set{Char}}, completed::Char)
    for key in keys(task_dict)
        delete!(task_dict[key], completed)
    end
end


function find_task_order(input)::Vector{Char}
    task_dict = create_task_dict(input)

    completed_tasks = Char[]
    while length(task_dict) > 0
        completed = get_next_task!(task_dict)
        update_task_dict!(task_dict, completed)
        push!(completed_tasks, completed)
    end
    return completed_tasks
end


input = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin."""

completed_tasks = find_task_order(input)
@test String(completed_tasks) == "CABDFE"


input_string = read(open("input.txt", "r"), String)
completed_tasks = find_task_order(input_string)
@show String(completed_tasks)
