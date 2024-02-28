# See: https://github.com/pocke/dotfiles/blob/master/bin/print-focused-ast.rb (original)
require 'optparse'

OPTION = {}

def line
  OPTION[:line].to_i
end

def column
  OPTION[:column].to_i
end

def has_target?(node)
  return false unless node.first_lineno <= line && line <= node.last_lineno

  if node.first_lineno == node.last_lineno
    return node.first_column <= column && column <= node.last_column
  elsif node.first_lineno == line
    return node.first_column <= column
  elsif node.last_lineno == line
    return column <= node.last_column
  else
    return true
  end
end


def find_target_node(node)
  return nil unless has_target?(node)

  node.children.each do |child|
    next unless child.is_a?(RubyVM::AbstractSyntaxTree::Node)
    ret = find_target_node(child)
    return ret if ret
  end

  node
end


opt = OptionParser.new
opt.parse!(ARGV, into: OPTION)

path, line_number = ARGV.first.split(':')
ARGV.replace [path]

OPTION[:line] = line_number.to_i

node = RubyVM::AbstractSyntaxTree.parse(ARGF.read)

pp find_target_node(node) || node
