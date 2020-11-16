# frozen_string_literal: true

class Node
  attr_accessor :value, :left, :right
  def initialize(value = nil, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end

class Tree
  attr_reader :pre_arr, :level_arr, :in_arr, :post_arr
  def initialize(array)
    @arr = array.uniq.sort
    @root = nil
  end

  def build_tree(arr = @arr, start = 0, last = (arr.length - 1))
    return nil if start > last

    mid = (start + last) / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr, start, mid - 1)
    root.right = build_tree(arr, mid + 1, last)
    @root = root
    root
  end

  def root
    @root.value
  end

  # Fix this insert function...
  def insert(value, node = @root)
    if node.nil?
      puts 'hi'
      node = Node.new(value)
      puts node.value
    elsif value > node.value
      if !node.right.nil?
        node = insert(value, node.right)
      else
        node.right = Node.new(value)
      end
    elsif value < node.value
      if !node.left.nil?
        node = insert(value, node.left)
      else
        node.left = Node.new(value)
      end
    end
    node
  end

  def delete_node(value, node = build_tree)
    return node.value if node.value.nil?

    if value < node.value
      delete_node(value, node.left)
    elsif value > node.value
      delete_node(value, node.right)
    else
      if node.left.nil? && node.right.nil?
        node.value = nil
      elsif node.left.nil?
        node.value = node.right.value
        node.right.value = nil
        node.value
      elsif node.right.nil?
        node.value = node.left.value
        node.left.value = nil
        node.value
      else
        temp = min_value_node(node.right)
        node.value = temp.value
        node.right = delete_node(temp.value, node.right)
      end
    end
    node.value
  end

  def min_value_node(node)
    current = node
    current = current.left while current && !current.left.nil?
    current
  end

  def find(value, node = @root)
    if node.nil? || node.value == value
      node
    elsif node.value < value
      find(value, node.right)
    else
      find(value, node.left)
    end
  end

  def level_order_rec(node = @root, queue = [], level_arr = [])
    level_arr.push(node.value) unless node.value.nil?
    queue.push(node.left) unless node.left.nil?
    queue.push(node.right) unless node.right.nil?
    level_order_rec(queue.shift, queue, level_arr) unless queue.empty?
    level_arr
  end

  def level_order_iter(node = build_tree)
    i = 0
    queue = [build_tree]
    while i < @arr.length
      node = queue.shift
      node.value unless node.value.nil?
      queue.push(node.left) unless node.left.nil?
      queue.push(node.right) unless node.right.nil?
      i += 1
    end
  end

  def preorder(node = @root, pre_arr = [])
    return if node.nil?

    pre_arr.push(node.value)
    preorder(node.left, pre_arr)
    preorder(node.right, pre_arr)
    pre_arr
  end

  def inorder(node = @root, in_arr = [])
    return if node.nil?

    inorder(node.left, in_arr)
    in_arr.push(node.value)
    inorder(node.right, in_arr)
    in_arr
  end

  def postorder(node = @root, post_arr = [])
    return if node.nil?

    postorder(node.left, post_arr)
    postorder(node.right, post_arr)
    post_arr.push(node.value)
    post_arr
  end

  def height(val)
    node = find(val)
    if node.left.nil? && node.right.nil?
      -1
    else
      left_height = height(node.left.value) unless node.left.nil?
      right_height = height(node.right.value) unless node.right.nil?
    end
    left_height = -1 if left_height.nil?
    right_height = -1 if right_height.nil?
    [left_height, right_height].max + 1
  end

  def depth(value, node = @root, depth = 0)
    nil if node.nil?

    if node.value < value
      depth += 1
      depth(value, node.right, depth)
    elsif node.value > value
      depth += 1
      depth(value, node.left, depth)
    else
      depth
    end
  end

  def balanced?(value = @root.value)
    node = find(value)
    nil if node.nil?

    if node.right.nil? && node.left.nil?
      true
    elsif node.right.nil?
      false if height(node.left.value).positive?
    elsif node.left.nil?
      false if height(node.right.value).positive?
    else
      (height(node.left.value) - height(node.right.value)).abs <= 1
    end
  end

  def rebalance
    @root = build_tree(inorder, 0, inorder.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

input = Array.new(15) { rand(1..100) }
new_tree = Tree.new(input)
new_tree.build_tree
puts "Balanced? #{new_tree.balanced?}"
puts 'level order, preorder, postorder, inorder'
p new_tree.level_order_rec
p new_tree.preorder
p new_tree.postorder
p new_tree.inorder
new_tree.insert(110)
new_tree.insert(120)
new_tree.insert(123)
new_tree.insert(125)
puts "\nBalanced? #{new_tree.balanced?}"
puts 'The inorder array tree is:'
p new_tree.inorder
puts 'With a root of'
p new_tree.root

puts "\nBalanced? #{new_tree.balanced?}"
new_tree.rebalance
p new_tree.balanced?
puts 'level order, preorder, postorder, inorder'
p new_tree.level_order_rec
p new_tree.preorder
p new_tree.postorder
p new_tree.inorder
new_tree.pretty_print
