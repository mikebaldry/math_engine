require 'rubygems'
require 'lexr'

require File.expand_path(File.join(File.dirname(__FILE__), 'math_lexer'))
require File.expand_path(File.join(File.dirname(__FILE__), 'math_parser'))

class MathEngine
  def evaluate(expression)
    MathParser.new(MathLexer.new(expression)).parse.evaluate
  end
end