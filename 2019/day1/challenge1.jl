using DelimitedFiles
using Test
using Printf


function fuel_requirement(mass)
    return floor(mass / 3) - 2
end


test1 = fuel_requirement(1969)
@test test1 == 654

test2 = fuel_requirement(100756)
@test test2 == 33583


challenge_input = readdlm("challenge_input1.txt", ' ', Int, '\n')[:]


fuel = sum(map(fuel_requirement, challenge_input))
@printf("%d\n", fuel)


function rocket_fuel_requirement(mass)
    total_fuel = 0
    fuel = fuel_requirement(mass)
    while fuel > 0
        total_fuel += fuel
        fuel = fuel_requirement(fuel)
    end
    return total_fuel
end


test3 = rocket_fuel_requirement(14)
println(test3)

test4 = rocket_fuel_requirement(1969)
println(test4)

test5 = rocket_fuel_requirement(100756)
println(test5)


rocket_fuel = sum(map(rocket_fuel_requirement, challenge_input))
@printf("%d\n", rocket_fuel)
