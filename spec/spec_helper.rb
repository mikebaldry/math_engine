require 'rspec'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'math_engine'))


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

def evaluate(line)
  MathEngine::MathEngine.new.evaluate(line)
end

def build_ast(line)
  MathEngine::MathEngine::Parser.new(MathEngine::MathEngine::Lexer.new(line)).parse
end

def print_ast(node, indent = "")
  puts "#{node.class.name} #{node.is_a?(MathEngine::MathEngine::Node) ? "" : "(#{node})"}"
  return unless node.is_a? MathEngine::MathEngine::Node

  print "#{indent}left: " if node.left
  print_ast(node.left, indent + "  ") if node.left

  print "#{indent}right: " if node.right
  print_ast(node.right, indent + "  ") if node.right
end
