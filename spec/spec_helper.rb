require 'spec'

require 'bundler'
Bundler.require

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'math_engine'))

def evaluate(line)
  MathEngine.new.evaluate(line)
end

def build_ast(line)
  MathEngine::Parser.new(MathEngine::Lexer.new(line)).parse
end

def print_ast(node, indent = "")
  puts "#{node.class.name} #{node.is_a?(MathEngine::Node) ? "" : "(#{node})"}"
  return unless node.is_a? MathEngine::Node
  
  print "#{indent}left: " if node.left
  print_ast(node.left, indent + "  ") if node.left
  
  print "#{indent}right: " if node.right
  print_ast(node.right, indent + "  ") if node.right
end