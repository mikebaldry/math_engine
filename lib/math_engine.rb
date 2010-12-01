require File.expand_path(File.join(File.dirname(__FILE__), 'errors'))
require File.expand_path(File.join(File.dirname(__FILE__), 'lexer'))
require File.expand_path(File.join(File.dirname(__FILE__), 'parser'))

class MathEngine
  def initialize()
    @variables = {}
    @functions = {}
  end
  
  def evaluate(expression)
    Parser.new(Lexer.new(expression)).parse.evaluate(self)
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
end