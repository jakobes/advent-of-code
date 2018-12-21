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


function get_next_task(task_dict::Dict{Char, Set{Char}})::Vector{Char}
    next_tasks = Char[]
    for key in keys(task_dict)
        if length(task_dict[key]) == 0
            push!(next_tasks, key)
        end
    end
    return sort(next_tasks)
end


function update_task_dict!(task_dict::Dict{Char, Set{Char}}, completed::Char)
    for key in keys(task_dict)
        delete!(task_dict[key], completed)
    end
end


input = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin."""


function find_task_order_with_help(input; available_workers::Int=2, work_delay::Int=0)
    task_dict = create_task_dict(input)

    queue = Dict{Int, Char}()
    num_workers = 0
    time = 0
    while length(task_dict) > 0 && time < 1e8
        if haskey(queue, time)
            update_task_dict!(task_dict, queue[time])
            num_workers -= 1
        end

        todo = get_next_task(task_dict)
        while length(todo) > 0 && available_workers - num_workers > 0
            num_workers += 1
            task = popfirst!(todo)
            delete!(task_dict, task)
            queue[time + Int(task) - 64 + work_delay] = task
        end
        time += 1
    end
    return queue
end


task_queue = find_task_order_with_help(input)
@test String([v[2] for v in sort(collect(task_queue), by=x->x[1])]) == "CABFDE"
@test maximum(keys(task_queue)) == 15

input_string = read(open("input.txt", "r"), String)
completed_tasks = find_task_order_with_help(input_string, available_workers=6, work_delay=60)
@show maximum(keys(completed_tasks))
