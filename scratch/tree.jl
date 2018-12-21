using Test


test_input = [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]


mutable struct TreeNode
    num_metadata::Int
    num_children::Int
    children::Vector{TreeNode}          # How to allocate memory for an array?
    metadata::Vector{Int}               # How to allocate memory for an array?
    TreeNode(num_metadata, num_children) = foobar(new(num_metadata, num_children))
end


function foobar(tree_node::TreeNode)::TreeNode
    tree_node.children = TreeNode[]
    tree_node.metadata = Int[]
    return tree_node
end


# foo = TreeNode(1)
# @show foo.metadata_length
# @show foo.data


#= function make_me_a_node!(test_input)::TreeNode =#
#=     num_children = popfirst!(test_input) =#
#=     num_metadata = popfirst!(test_input) =#
#=     parent = TreeNode(num_children, num_metadata) =#
#=     return parent =#
#= end =#


#= function make_tree!(test_input)::TreeNode =#
#=     node::TreeNode = make_me_a_node!(test_input) =#

#=     if node.num_children > 0 =#
#=         for i in 1:node.num_children =#
#=         #1=     #2= child = make_me_a_node!(test_input) =2# =1# =#
#=             child = make_tree!(test_input) =#
#=             push!(node.children, child) =#
#=             return node =#
#=         end =#
#=     end =#

#=     for i in 1:node.num_metadata =#
#=         push!(node.metadata, popfirst!(test_input)) =#
#=     end =#

#=     return node =#
#= end =#


#= foo = make_tree!(test_input) =#
#= @show foo =#


#= for a in test_input =#
#
#=     @show a =#
#= end =#




#= foo = read(open("input.txt", "r")) =#
#= @show foo =#



