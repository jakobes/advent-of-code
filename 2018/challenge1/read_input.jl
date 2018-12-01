using DelimitedFiles

my_array = readdlm("input.txt", ' ', Int, '\n')
println(sum(my_array))
