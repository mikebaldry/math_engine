MathLexer = Lexr.that {
	ignores /\s/ => :whitespace
	matches /[a-z][a-z0-9]*/ => :identifier, :convert_with => lambda { |v| v.to_sym }
	matches /[-+]?[0-9]*\.?[0-9]+/ => :number, :convert_with => lambda { |v| Float(v) }
	matches '=' => :assignment
	matches '+' => :addition
	matches '-' => :subtraction
	matches '*' => :multiplication
	matches '/' => :division
	matches '(' => :open_parenthesis
	matches ')' => :close_parenthesis
}