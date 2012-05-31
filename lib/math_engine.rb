require 'mathn'
require File.expand_path(File.join(File.dirname(__FILE__), 'errors'))
require File.expand_path(File.join(File.dirname(__FILE__), 'lexer'))
require File.expand_path(File.join(File.dirname(__FILE__), 'parser'))
class MathEngine
  def initialize(case_sensitive = true)
    @variables = {}
    @dyn_library = Class.new.new
    @libraries = [@dyn_library, Math]
    @case_sensitive = case_sensitive
  end
  
  def evaluate(expression)
    Parser.new(Lexer.new(expression)).parse.evaluate(self)
  end
  
  def set(variable_name, value)
    if @case_sensitive
      raise UnableToModifyConstant.new(variable_name) if constants.include? variable_name
    else
      raise UnableToModifyConstant.new(variable_name) if constants.include? variable_name.upcase
    end
    @variables[variable_name] = value
  end
  
  def get(variable_name)
    if @case_sensitive
      raise UnknownVariableError.new(variable_name) unless @variables.keys.include? variable_name
      @variables[variable_name]
    else
      raise UnknownVariableError.new(variable_name) unless (variables.include?(variable_name) || constants.include?(variable_name.upcase))
       @variables.each_with_object({}) {|(k,v),h| h[k.downcase]=v}[variable_name.downcase]
    end
  end
  
  def variables
    @variables.keys.collect { |k| k.to_s }.reject { |v| v.downcase != v }.sort.collect { |k| k.to_sym }
  end
  
  def constants
    @variables.keys.collect { |k| k.to_s }.reject { |v| v.upcase != v }.sort.collect { |k| k.to_sym }
  end
  
  def call(name, *parameters)
    name = name.downcase unless @case_sensitive
    cls = class_for_function(name)
    raise UnknownFunctionError.new(name) unless cls
    cls.send name, *parameters
  end
  
  def define(name, func = nil, &block)
    name = name.downcase unless @case_sensitive
    @dyn_library.class.send :define_method, name.to_sym do |*args|
      func ? func.call(*args) : block.call(*args)
    end
  end
  
  def include_library(library)
    @libraries << library
  end
  
  private
  
  def class_for_function(name)
    @libraries.detect { |l| l.methods.include? name }
  end
end
