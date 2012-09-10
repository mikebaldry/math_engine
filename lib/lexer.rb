class MathEngine
  Lexer = Lexr.that {
    ignores /\s/ => :whitespace
    
    legal_place_for_binary_operator = lambda { |prev| [:addition, 
                                                       :subtraction, 
                                                       :multiplication, 
                                                       :division,
                                                       :open_parenthesis,
                                                       :start].include? prev.type }
    
    matches ',' => :comma
    matches '=' => :assignment
    matches '+' => :addition, :unless => legal_place_for_binary_operator
    matches '-' => :subtraction, :unless => legal_place_for_binary_operator
    matches '*' => :multiplication, :unless => legal_place_for_binary_operator
    matches '/' => :division, :unless => legal_place_for_binary_operator
    matches '^' => :exponent, :unless => legal_place_for_binary_operator
    matches '%' => :modulus, :unless => legal_place_for_binary_operator
    matches '(' => :open_parenthesis
    matches ')' => :close_parenthesis
    
    matches /([-+]?(\d+\.?\d*|\d*\.?\d+)([Ee][-+]?[0-2]?\d{1,2})?[r]?|[-+]?((\d+\.?\d*|\d*\.?\d+)([Ee][-+]?[0-2]?\d{1,2})?)?[i]|[-+]?(\d+\.?\d*|\d*\.?\d+)([Ee][-+]?[0-2]?\d{1,2})?[r]?[-+]((\d+\.?\d*|\d*\.?\d+)([Ee][-+]?[0-2]?\d{1,2})?)?[i])/ => :number, :convert_with => lambda { |v| BigDecimal(v) }
    matches /[a-z][a-z0-9_]*/i => :identifier, :convert_with => lambda { |v| v.to_sym }
  }
end
