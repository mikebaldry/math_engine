require 'rubygems'
require 'lexr'

require File.expand_path(File.join(File.dirname(__FILE__), 'math_lexer'))
require File.expand_path(File.join(File.dirname(__FILE__), 'math_parser'))

class MathEngine
  def initialize()
    @variables = {}
    @functions = {}
  end
  
  def evaluate(expression)
    MathParser.new(MathLexer.new(expression)).parse.evaluate(self)
  end
  
  def set(variable_name, value)
    raise UnableToModifyConstant.new(variable_name) if @variables.keys.include? variable_name and variable_name.to_s == variable_name.to_s.upcase
    @variables[variable_name] = value
  end
  
  def get(variable_name)
    raise UnknownVariableError.new(variable_name) unless @variables.keys.include? variable_name
    @variables[variable_name]
  end
  
  def variables
    @variables.keys.collect { |k| k.to_s }.sort.collect { |k| k.to_sym }
  end
  
  def functions
    @functions.keys.collect { |k| k.to_s }.sort.collect { |k| k.to_sym }
  end
  
  def call(function_name, *parameters)
    raise UnknownFunctionError.new(function_name) unless @functions.keys.include? function_name
    func = @functions[function_name]
    raise ArgumentCountError.new(function_name, func.arity, parameters.length) if func.arity != parameters.length
    func.call(*parameters)
  end
  
  def define(function_name, func = nil, &block)
    @functions[function_name] = func ? func : block
  end
  
  class UnknownVariableError < StandardError
    def initialize(variable_name)
      @variable_name = variable_name
    end
    
    def to_s
      "Variable '#{@variable_name}' was referenced but does not exist"
    end
  end
  
  class UnknownFunctionError < StandardError
    def initialize(function_name)
      @function_name = function_name
    end
    
    def to_s
      "Function '#{@function_name}' was referenced but does not exist"
    end
  end
  
  class UnableToModifyConstant < StandardError
    def initialize(constant_name)
      @constant_name = constant_name
    end
    
    def to_s
      "Unable to modify value of constant '#{@constant_name}'"
    end
  end
  
  class ArgumentCountError < StandardError
    def initialize(function_name, arguments_taken, arguments_called_with)
      @function_name = function_name
      @arguments_taken, @arguments_called_with = arguments_taken, arguments_called_with
    end
    
    def to_s
      "Function '#{@function_name}' takes #{@arguments_taken} but was called with #{@arguments_called_with}"
    end
  end
end