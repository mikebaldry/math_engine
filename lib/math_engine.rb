require 'rubygems'
require 'lexr'

require File.expand_path(File.join(File.dirname(__FILE__), 'math_lexer'))
require File.expand_path(File.join(File.dirname(__FILE__), 'math_parser'))

class MathEngine
  def initialize
    @variables = {}
  end
  
  def evaluate(expression)
    MathParser.new(MathLexer.new(expression)).parse.evaluate(self)
  end
  
  def set(variable_name, value)
    @variables[variable_name] = value
  end
  
  def get(variable_name)
    raise UnknownVariableError.new(variable_name) unless @variables.keys.include? variable_name
    @variables[variable_name]
  end
  
  def variables
    @variables.keys.collect { |k| k.to_s }.sort.collect { |k| k.to_sym }
  end
  
  class UnknownVariableError < StandardError
    def initialize(variable_name)
      @variable_name = variable_name
    end
    
    def to_s
      "Variable '#{@variable_name}' was referenced but does not exist"
    end
  end
end