MathLexer = Lexr.that {
	ignores /\s/ => :whitespace
	matches /[-+]?[0-9]*\.?[0-9]+/ => :number, :convert_with => lambda { |v| Float(v) }
	matches '+' => :addition
	matches '-' => :subtraction
	matches '*' => :multiplication
	matches '/' => :division
	matches '(' => :open_parenthesis
	matches ')' => :close_parenthesis
}