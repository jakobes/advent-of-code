using Test


function read_file(filename="input.txt")
    file = readlines(filename)

    plant_set = Set{Int}()
    for (i, pot) in enumerate(collect(match(r"[#.]+", file[1]).match))
        if pot == '#'
            push!(plant_set, i - 1)
        end
    end

    rule_set = Set{String}()
    for line in file[3: end]
        if line[end] == '#'
            rule = String(collect(match(r"[#.]+", line).match))
            push!(rule_set, rule)
        end
    end
    return plant_set, rule_set
end


function next_generation(plant_set::Set{Int}, rule_set::Set{String})::Set{Int}
    start = minimum(plant_set)
    stop = maximum(plant_set)

    new_plants = Set{Int}()
    for i in start - 5: stop + 5        # safe margins
        pattern = String([i + k in plant_set ? '#' : '.' for k in range(-2, length=5)])
        if pattern in rule_set
            push!(new_plants, i)
        end
    end
    return new_plants
end


function grow_plants(plant_set, rule_set, num_generations)
    for i in 1:num_generations
        plant_set = next_generation(plant_set, rule_set)
    end
    return plant_set
end


test_plants = Set{Int}([0, 3, 5, 8, 9, 16, 17, 18, 22, 23, 24])
test_rules = Set{String}([
    "...##",
    "..#..",
    ".#...",
    ".#.#.",
    ".#.##",
    ".##..",
    ".####",
    "#.#.#",
    "#.###",
    "##.#.",
    "##.##",
    "###..",
    "###.#",
    "####."
])

plants = grow_plants(test_plants, test_rules, 20)
@test sum(plants) == 325


# Part 1
plant_set, rule_set = read_file()
# @show sort(collect(plant_set))
plants = grow_plants(plant_set, rule_set, 20)
@show sum(plants)
