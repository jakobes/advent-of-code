using Test

struct TreeNode
    name::String
    out_paths::Set{String}
end

TreeNode(name::String) = TreeNode(name, Set{String}())
is_uppercase(name) = all(c -> isuppercase(c), name)


function add_connection(tree::Dict{String, TreeNode}, start_name, stop_name)
    start = tree[start_name]
    stop = tree[stop_name]

    push!(start.out_paths, stop_name)
    push!(stop.out_paths, start_name)
end


function walk_tree(tree::Dict{String, TreeNode}, start::String, visited::Array{String, 1}, paths::Array{Array{String, 1}, 1}, allowed_twice::String)
    push!(visited, start)
    start_node = tree[start]

    for out_name in start_node.out_paths
        if out_name == "end"
            continue
        end

        out_node = tree[out_name]
        seen_twice = out_name == allowed_twice && length(filter(x -> x == allowed_twice, visited)) != 2
        if is_uppercase(out_name) || !(out_name in visited) || seen_twice
            walk_tree(tree, out_name, copy(visited), paths, allowed_twice)
        end
    end

    if "end" in start_node.out_paths
        push!(visited, "end")
        push!(paths, visited)
        return
    end
end


tree = Dict{String, TreeNode}()

start_node = TreeNode("start")
tree[start_node.name] = start_node

stop_node = TreeNode("end")
tree[stop_node.name] = stop_node

f = open("input.txt", "r")
while !eof(f)
    line = readline(f)
    # @show line
    start_name, stop_name = map(String, split(line, "-"))

    if !(start_name in keys(tree))
        local start_node = TreeNode(start_name)
        tree[start_name] = start_node
    end

    if !(stop_name in keys(tree))
        local stop_node = TreeNode(stop_name)
        tree[stop_name] = stop_node
    end

    @test start_name in keys(tree)
    @test stop_name in keys(tree)

    add_connection(tree, start_name, stop_name)
end
close(f)

# Set of all lowercase names
small_keys = Set(filter(!is_uppercase, filter(x -> !(x in Set(["start", "end"])), keys(tree))))

unique_paths = Set{String}()
for allowed_twice in small_keys
    paths = Array{Array{String, 1}, 1}()
    walk_tree(tree, "start", String[], paths, allowed_twice)
    path_id_set = Set(map(join, paths))
    @show length(path_id_set)
    global unique_paths = union(unique_paths, path_id_set)
end
@show length(unique_paths)
