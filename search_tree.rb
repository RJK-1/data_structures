# Class that stores each node
class Node
  attr_accessor :node, :left, :right

  def initialize(node)
    @node = node
    @left = nil
    @right = nil
  end
end

# Class that builds tree and performs several methods on it
class Tree
  attr_accessor :root

  def initialize(array)
    @array = array
    @root = build_tree(@array)
  end

  def build_tree(array)
    return nil if array.empty?

    sorted_array = array.uniq.sort
    middle_index = (sorted_array.length.to_f / 2).ceil - 1
    node = Node.new(sorted_array[middle_index])
    node.left = build_tree(sorted_array[0, middle_index])
    node.right = build_tree(sorted_array[middle_index + 1..-1])
    node
  end

  def insert(value, node = @root, parent = nil, dir = nil)
    if node.nil?
      dir == 'left' ? parent.left = Node.new(value) : parent.right = Node.new(value)
      return
    elsif value == node.node || value == node.right || value == node.left
      return
    end
    parent = node
    value > node.node ? insert(value, node.right, parent, 'right') : insert(value, node.left, parent, 'left')
  end

  def delete(value, node = @root, parent = nil)
    if value == node.node
      if node.left.nil? && node.right.nil? # Delete a node with no children
        value > parent.node ? parent.right = nil : parent.left = nil
      elsif (!node.left.nil? && node.right.nil?) || (node.left.nil? && !node.right.nil?) # Node only has one child
        if node.node > parent.node
          node.left.nil? ? parent.right = node.right : parent.right = node.left
        else
          node.left.nil? ? parent.left = node.right : parent.left = node.left
        end
      elsif !node.right.nil? && !node.left.nil? # more than one child
        right_child = node.right
        left_child = node.left
        if !right_child.left.nil?
          parent.right = right_child
          parent.right.left = left_child
        else
          temp = right_child.left
          right_child.left = nil
          parent.right = temp
          parent.right.left = left_child
          parent.right.right = right_child
        end
      end
    else
      parent = node
      value > node.node ? delete(value, node.right, parent) : delete(value, node.left, parent)
    end
  end

  def find(value, node = @root)
    return nil if node.nil?

    return node if value == node.node

    value > node.node ? find(value, node.right) : find(value, node.left)
  end

  def level_order(node = @root)
    queue = []
    array = []
    queue << node
    queue.each do |node|
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
      array << node.node
    end
    array
  end

  def inorder(node = @root)
    return if node.nil?

    inorder(node.left)
    print "#{node.node} "
    inorder(node.right)
  end

  def preorder(node = @root)
    return if node.nil?

    print "#{node.node} "
    preorder(node.left)
    preorder(node.right)
  end

  def postorder(node = @root)
    return if node.nil?

    postorder(node.left)
    postorder(node.right)
    print "#{node.node} "
  end

  def height(value, node = 0)
    node = find(value) unless value.nil?
    return -1 if node.nil?

    [height(nil, node.left), height(nil, node.right)].max + 1
  end

  def depth(value)
    node = find(value) unless value.nil?
    ref_node = @root
    depth = 0
    until node == ref_node
      ref_node = node.node > ref_node.node ? ref_node.right : ref_node.left
      depth += 1
    end
    depth
  end

  def balanced?(node = @root)
    left = height(nil, node.left) + 1
    right = height(nil, node.right) + 1
    diff = left > right ? left - right : right - left
    diff <= 1
  end

  def rebalance
    array = level_order
    @root = build_tree(array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.node}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

tree.pretty_print
puts tree.balanced? ? 'Tree is balanced' : 'Tree is not balanced'

puts 'Level Order Traversal:'
p tree.level_order

puts 'Pre-Order Traversal:'
puts tree.preorder

puts 'In-Order Traversal:'
puts tree.inorder

puts 'Post-Order Traversal:'
puts tree.postorder

tree.insert(203)
tree.insert(157)
tree.insert(306)
tree.pretty_print
puts tree.balanced? ? 'Tree is balanced' : 'Tree is not balanced'

tree.rebalance
tree.pretty_print
puts tree.balanced? ? 'Tree is balanced' : 'Tree is not balanced'

puts 'Level Order Traversal:'
p tree.level_order

puts 'Pre-Order Traversal:'
puts tree.preorder

puts 'In-Order Traversal:'
puts tree.inorder

puts 'Post-Order Traversal:'
puts tree.postorder
