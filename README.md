# MathEngine

MathEngine is a lightweight mathematical expression parser and evaluator. It currently handles addition, subtraction, multiplication, division, exponent, modulus and the use of variables and pre-defined functions.

Install with

	gem install math_engine

The only dependency is on my other gem, lexr[http://github.com/michaelbaldry/lexr], which is really lightweight and has no external dependencies.

## An example: Expressions

	require 'rubygems'
	require 'math_engine'

	engine = MathEngine.new

	puts "#{engine.evaluate("x = 10 * (3 * 2) + (55 - 5) / (2.5 * (3 + 1))")}"
	puts "#{engine.evaluate("x + 5")}"

results in an output of

	65.0
	70.0
	
if you missed a closing parenthesis, had an operator where it wasn't meant to be, you might get something like this:

	Unexpected multiplication(*), expected: number, variable name or open_parenthesis
	
and that is pretty much every feature so far. Please let me know of any bugs or additions that you'd like to see!

## License

See the LICENSE file included with the distribution for licensing and
copyright details.