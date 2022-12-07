# frozen_string_literal: true

# tree structure
class FileTree
  attr_reader :value, :parent, :children

  def initialize(value, parent)
    @value = value
    @parent = parent
    @children = []
  end

  def add_child(value)
    new_child = self.class.new(value, self)
    children.push(new_child)
  end

  def size = dir? ? children.sum(&:size) : value

  def dir? = value.is_a?(String)

  def get_child(value) = children.find { |child| child.value == value }
end

input = File.readlines(*ARGV, chomp: true)

tree = FileTree.new("/", nil)
current = tree

input[1..].each do |line|
  if line[0..2] == "dir"
    dir_name = line[4..]
    current.add_child(dir_name)
  elsif /\d+/.match?(line)
    file_name = line.scan(/\d+/).join.to_i
    current.add_child(file_name)
  elsif line.include?("..")
    current = current.parent
  elsif line[2..3] == "cd"
    current = current.get_child(line[5..])
  else
    next
  end
end

def size_of_dirs_under_100k(node, size = 0)
  return size unless node.dir?

  size += node.size if node.size <= 100_000

  node.children.reduce(size) do |memo, child|
    size_of_dirs_under_100k(child, memo)
  end
end

TOTAL_SPACE =  70_000_000
UNUSED_SPACE = TOTAL_SPACE - tree.size
SPACE_NEEDED = 30_000_000
MIN_DEL_SIZE = SPACE_NEEDED - UNUSED_SPACE

def search_for_smallest_delete(node, smallest = Float::INFINITY)
  return smallest unless node.dir?
  return smallest if node.size < MIN_DEL_SIZE

  smallest = [smallest, node.size].min
  node.children.reduce(smallest) do |memo, child|
    search_for_smallest_delete(child, memo)
  end
end

p size_of_dirs_under_100k(tree) # p1-> 1915606

p search_for_smallest_delete(tree) # p2-> 5025657
