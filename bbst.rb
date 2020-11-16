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
    @queue = []
    @pre_arr = []
    @level_arr = []
    @in_arr = []
    @post_arr = []
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

  def insert(value, node = build_tree)
    if node.nil?
      new_node = Node.new(value)
      new_node.value
    elsif value < node.value
      insert(value, node.left)
    elsif value > node.value
      insert(value, node.right)
    end
  end

  def delete_node(value, node = build_tree)
    if node.value.nil?
      return node.value
    end

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
    while current && current.left != nil
      current = current.left
    end
    current
  end

  def find(value, node = build_tree)
    if node.nil? || node.value == value
      node
    elsif node.value < value
      find(value, node.right)
    else
    find(value, node.left)
    end
  end

  def level_order_rec(node = build_tree)
    @level_arr.push(node.value) unless node.value.nil?
    @queue.push(node.left) unless node.left.nil?
    @queue.push(node.right) unless node.right.nil?
    level_order_rec(@queue.shift) unless @queue.empty?
  end

  def level_order_iter(node = build_tree)
    i = 0
    queue = [build_tree]
    while i < @arr.length
      node = queue.shift
      node.value unless node.value.nil?
      queue.push(node.left) unless node.left.nil?
      queue.push(node.right) unless node.right.nil?
      i+=1
    end
  end

  def preorder(node = @root)
    return if node.nil?

    @pre_arr.push(node.value)
    preorder(node.left)
    preorder(node.right)
  end

  def inorder(node = @root)
    return if node.nil?

    inorder(node.left)
    @in_arr.push(node.value)
    inorder(node.right)
  end

  def postorder(node = @root)
    return if node.nil?

    postorder(node.left)
    postorder(node.right)
    @post_arr.push(node.value)
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
      false if height(node.left.value)>0
    elsif node.left.nil?
      false if height(node.right.value)>0
    elsif (height(node.left.value)-height(node.right.value)).abs >1
      false
    end
    true
  end

  def rebalance
    @root = build_tree(@in_arr, 0, @level_arr.length)
  end
end

ek = Tree.new([1,2,3,4,5,6,7,8,9])
ek.build_tree
ek.delete_node(2)
ek.find(6)
ek.level_order_rec
ek.level_order_iter
ek.preorder
ek.inorder
ek.postorder
p ek.level_arr
p ek.pre_arr
p ek.in_arr
p ek.post_arr
puts ek.height(8)
puts ek.depth(9)
puts ek.balanced?(5)
puts ek.rebalance.value