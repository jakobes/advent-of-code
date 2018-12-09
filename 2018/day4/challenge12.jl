using Test


function parse_log(sample_log)
    guard_dict = Dict{Int, Vector{Int}}()
    fell_asleep = 0
    global guard_id = nothing

    for (i, line) in enumerate(sort(sample_log))
        time_id = parse(Int, match(r".*:(\d+)", line)[1])
        date = match(r".*(\d\d\-\d\d)", line)[1]        # This looks stupid

        if occursin("falls asleep", line)
            fell_asleep = time_id
        elseif occursin("wakes up", line)
            if !haskey(guard_dict, guard_id)
                guard_dict[guard_id] = zeros(Int, 60)
            end
            for i = fell_asleep + 1: time_id        # inclusive or exclusive?
                guard_dict[guard_id][i] += 1
            end
        else
            guard_id = parse(Int, match(r".*#(\d+)", line)[1])
        end
    end
    return guard_dict
    # return guard_log
end


function find_max_key(my_dict::Dict{Int, Vector{Int}})
    return reduce((x, y) -> sum(my_dict[x]) >= sum(my_dict[y]) ? x : y, keys(my_dict))
end


function find_frequent_key(my_dict::Dict{Int, Vector{Int}})
    maxval = -1
    maxidx = nothing
    maxkey = nothing
    for key in keys(my_dict)
        tmp_val, tmp_idx = findmax(my_dict[key])
        if tmp_val > maxval
            maxval = tmp_val
            maxidx = tmp_idx
            maxkey = key
        end
    end
    return maxkey, maxidx
end


sample_log = [
    "[1518-11-01 00:00] Guard #10 begins shift",
    "[1518-11-01 00:05] falls asleep",
    "[1518-11-01 00:25] wakes up",
    "[1518-11-01 00:30] falls asleep",
    "[1518-11-01 00:55] wakes up",
    "[1518-11-01 23:58] Guard #99 begins shift",
    "[1518-11-02 00:40] falls asleep",
    "[1518-11-02 00:50] wakes up",
    "[1518-11-03 00:05] Guard #10 begins shift",
    "[1518-11-03 00:24] falls asleep",
    "[1518-11-03 00:29] wakes up",
    "[1518-11-04 00:02] Guard #99 begins shift",
    "[1518-11-04 00:36] falls asleep",
    "[1518-11-04 00:46] wakes up",
    "[1518-11-05 00:03] Guard #99 begins shift",
    "[1518-11-05 00:45] falls asleep",
    "[1518-11-05 00:55] wakes up"
]


guard_dict = parse_log(sample_log)
max_key = find_max_key(guard_dict)

maxval, maxind = findmax(guard_dict[max_key])
@test max_key*(maxind - 1) == 240

# Part 2 test
guard_id, minute_index = find_frequent_key(guard_dict)
@test guard_id*(minute_index - 1) == 4455



input_log = open("input.txt", "r") do input_file
   input_claims = [line for line in eachline(input_file)]
end

guard_dict = parse_log(input_log)
max_key = find_max_key(guard_dict)

maxval, maxind = findmax(guard_dict[max_key])
println("part 1")
println((maxind - 1)*max_key)

println("part 2")
guard_id, minute_index = find_frequent_key(guard_dict)
println(guard_id*(minute_index - 1))
