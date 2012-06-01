# MathEngine

MathEngine is a lightweight mathematical expression parser and evaluator. It currently handles addition, subtraction, multiplication, division, exponent, modulus and the use of variables and pre-defined functions.

Install with

	gem install math_engine

The only dependency is [lexr](http://github.com/michaelbaldry/lexr), which is really lightweight and has no external dependencies.

## An example: Expressions

	require 'rubygems'
	require 'math_engine'

	engine = MathEngine.new

	puts "#{engine.evaluate("x = 10 * (3 * 2) + (55 - 5) / (2.5 * (3 + 1))")}"
	puts "#{engine.evaluate("x + 5")}"

results in an output of

	65.0
	70.0

extending is easy using functions, you can add single functions using MathEngine.define
	
	engine.context.define :add_em do |x, y|
		x + y
	end
	
or you can write all your functions in a class and add the class

	class SomeFunctions
		def add_em(x, y)
			x + y
		end
	end

	engine.context.include_library SomeFunctions.new
	
and calling them with

	engine.evaluate("1 + 1 + add_em(2, 2)")
	
All functions are pulled in from the built in Math class by default, so all the standard ruby math functions are available (cos, sin, tan etc)

if you missed a closing parenthesis, had an operator where it wasn't meant to be, you might get something like this:

	Unexpected multiplication(*), expected: number, variable name or open_parenthesis
	
and that is pretty much every feature so far. Please let me know of any bugs or additions that you'd like to see!

## Contributors

Mario de la Ossa (mdelaossa): Handling of complex numbers and upgraded to work with 1.9.X

## License

See the LICENSE file included with the distribution for licensing and
copyright details.
