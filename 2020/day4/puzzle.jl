using DelimitedFiles


function check_height(metric, height)
    if metric == "cm"
        return 150 <= height <= 193
    elseif metric == "in"
        return 59 <= height <= 76
    end
    return false
end


open("real_input.txt") do f
    s = read(f, String)
    passport_array = split(s, "\n\n")

    pattern = r"(\w+):(\#?\w+)\n?"
    pattern_four_digits = r"^(\d{4})$"
    pattern_hgt = r"^(\d+)(cm|in)$"
    pattern_hcl = r"^(\#[0-9a-f]{6})$"
    ecl_set = Set{String}(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
    pattern_pid = r"^(\d{9})$"

    required_fields = Set{String}(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"])
    valid_passports = 0
    foo = Set()
    for passport in passport_array
        tmp_dict = Dict{String, String}()
        map(x -> tmp_dict[x[1]] = x[2], eachmatch(pattern, passport))

        diff = setdiff(required_fields, Set(keys(tmp_dict)))
        if length(diff) == 0 || diff == Set{String}(["cid"])

            m_byr = match(pattern_four_digits, tmp_dict["byr"])
            m_iyr = match(pattern_four_digits, tmp_dict["iyr"])
            m_eyr = match(pattern_four_digits, tmp_dict["eyr"])
            m_hgt = match(pattern_hgt, tmp_dict["hgt"])
            m_hcl = match(pattern_hcl, tmp_dict["hcl"])
            m_pid = match(pattern_pid, tmp_dict["pid"])

            if m_byr == nothing || !(1920 <= parse(Int, m_byr[1]) <= 2002)
                continue
            elseif m_iyr == nothing || !(2010 <= parse(Int, m_iyr[1]) <= 2020)
                continue
            elseif m_eyr == nothing || !(2020 <= parse(Int, m_eyr[1]) <= 2030)
                continue
            elseif m_hgt == nothing || !check_height(m_hgt[2], parse(Int, m_hgt[1]))
                continue
            elseif m_hcl == nothing
                continue
            elseif !in(tmp_dict["ecl"], ecl_set)
                continue
            elseif m_pid == nothing
                continue
            end

            @show tmp_dict["byr"]

            valid_passports += 1
        end
    end
    @show valid_passports
end
