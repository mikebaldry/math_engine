module MathEngine
  require 'rubygems'
  require 'lexr'

  class MathEngine
    Lexer = Lexr.that {
      ignores /\s/ => :whitespace
      matches /[a-z][a-z0-9_]*/ => :identifier, :convert_with => lambda { |v| v.to_sym }
      #matches /[-+]?[0-9]*\.?[0-9]+/ => :number, :convert_with => lambda { |v| Integer(v) rescue Float(v) }
      matches /([^\d\)][-+]{1})?[0-9]*\.?[0-9]+/ => :number, :convert_with => lambda { |v| Float(v) }
      matches ',' => :comma
      matches '=' => :assignment
      matches '+' => :addition
      matches '-' => :subtraction
      matches '*' => :multiplication
      matches '/' => :division
      matches '^' => :exponent
      matches '%' => :modulus
      matches '(' => :open_parenthesis
      matches ')' => :close_parenthesis
    }
  end
end
