# MathEngine

MathEngine is a lightweight mathematical expression parser and evaluator. It currently handles addition, subtraction, multiplication and division, but support is planned for other operators and variables, etc.

Install with

	gem install math_engine

## An example: Expressions

	require 'rubygems'
	require 'math_engine'

	puts "#{MathEngine.new.evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * (3 + 1))")}"

results in an output of

	65.0
	
if you missed a closing parenthesis, had an operator where it wasn't meant to be, you might get something like this:

	Unexpected multiplication(*), expected: number or open_parenthesis
	
and that is pretty much every feature so far. Please let me know of any bugs or additions that you'd like to see!