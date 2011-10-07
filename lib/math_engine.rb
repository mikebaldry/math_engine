require File.expand_path(File.join(File.dirname(__FILE__), 'errors'))
require File.expand_path(File.join(File.dirname(__FILE__), 'lexer'))
require File.expand_path(File.join(File.dirname(__FILE__), 'parser'))

class MathEngine
  def initialize()
    @variables = {}
    @dyn_library = Class.new.new
    @libraries = [@dyn_library, Math]
  end

  def evaluate(expression)
    Parser.new(Lexer.new(expression)).parse.evaluate(self)
  end

  def parse_to_tex(expression)
    "$#{Parser.new(Lexer.new(expression)).parse.to_tex}$"
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
    @variables.keys.collect { |k| k.to_s }.reject { |v| v.downcase != v }.sort.collect { |k| k.to_sym }
  end

  def constants
    @variables.keys.collect { |k| k.to_s }.reject { |v| v.upcase != v }.sort.collect { |k| k.to_sym }
  end

  def call(name, *parameters)
    cls = class_for_function(name)
    raise UnknownFunctionError.new(name) unless cls
    cls.send name, *parameters
  end

  def define(name, func = nil, &block)
    @dyn_library.class.send :define_method, name.to_sym do |*args|
      func ? func.call(*args) : block.call(*args)
    end
  end

  def include_library(library)
    @libraries << library
  end

  private

  def class_for_function(name)
    @libraries.detect { |l| l.methods.map{|m| m.to_s}.include? name.to_s }
  end
end
