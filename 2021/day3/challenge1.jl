using Test
using DelimitedFiles
using DataStructures


function compute_rates(diagnostic)
    rate_dict = DefaultDict{Integer, Integer}(0)
    number_of_entries = 0
    for i = 1:length(diagnostic)
        number_of_entries += 1
        for j = 1:length(diagnostic[i])
            rate_dict[j] += parse(Int64, diagnostic[i][j])
        end
    end

    gamma_rate_array = [rate_dict[key] > number_of_entries / 2 ? 1 : 0 for key in sort(collect(keys(rate_dict)))]
    gamma_rate = parse(Int, join(string.(gamma_rate_array)), base=2)

    epsilon_rate_array = [rate_dict[key] < number_of_entries / 2 ? 1 : 0 for key in sort(collect(keys(rate_dict)))]
    epsilon_rate = parse(Int, join(string.(epsilon_rate_array)), base=2)

    return gamma_rate, epsilon_rate
end


test_diagnostic = [
    "00100", "11110", "10110", "10111", "10101", "01111",
    "00111", "11100", "10000", "11001", "00010", "01010"
   ]
@show test_diagnostic
test_gamma, test_epsilon = compute_rates(test_diagnostic)
@test test_gamma*test_epsilon == 198

real_diagnostic = readdlm("input.txt", ' ', String, '\n')[:]
real_gamma, real_epsilon = compute_rates(real_diagnostic)
@show real_gamma, real_epsilon, real_gamma*real_epsilon

# Task 2

function most_common_bit(diagnostic, position, max_bits)
    count = 0
    for i = 1:length(diagnostic)
        foo = (diagnostic[i] >> (max_bits - 1 - position)) & 1
        count += foo
    end
    return count
end


function life_support_rates(diagnostic)
    max_bits = length(diagnostic[1])
    oxygen_diagnostic = map(x -> parse(Int64, x, base=2), diagnostic)
    co2_diagnostic = map(x -> parse(Int64, x, base=2), diagnostic)
    for i = 0:max_bits - 1
        # Oxygen -- 1 if 0 and 1 are tied
        oxygen_length = length(oxygen_diagnostic)
        if oxygen_length > 1
           most_common = most_common_bit(oxygen_diagnostic, i, max_bits) >= oxygen_length / 2 ? 1 : 0
           oxygen_diagnostic = filter(x -> (x >> (max_bits - 1 - i) & 1) == most_common, oxygen_diagnostic)
       end

        # Co2 -- 0 if 0 and 1 are tied
        co2_length = length(co2_diagnostic)
        if co2_length > 1
            least_common = most_common_bit(co2_diagnostic, i, max_bits) < co2_length / 2 ? 1 : 0
            co2_diagnostic = filter(x -> (x >> (max_bits - 1 - i) & 1) == least_common, co2_diagnostic)
        end

        # oxygen = map(x -> string(x, base=2, pad=5), oxygen_diagnostic)
        # @show oxygen

        # co2 = map(x -> string(x, base=2, pad=5), co2_diagnostic)
        # @show co2
        if oxygen_length == 1 && co2_length == 1
            break
        end
    end
    return oxygen_diagnostic[1], co2_diagnostic[1]
end


oxygen, co2 = life_support_rates(test_diagnostic)
@show oxygen, co2, oxygen*co2

oxygen, co2 = life_support_rates(real_diagnostic)
@show oxygen, co2, oxygen*co2
