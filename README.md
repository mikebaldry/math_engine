# MathEngine

MathEngine is a lightweight mathematical expression parser and evaluator.
It currently handles addition, subtraction, multiplication, division, exponent,
modulus and the use of variables and pre-defined functions.

In addtional MathEgine is parse from normal equation to latex format,
  This feature it currently handles
  addition, subtraction, multiplication, division, exponent and sqrt

# Install in rails
	
	Added in your Gemfile
	gem 'math_engine', '~> 0.3.0', :git => 'git@github.com:dmarczal/math_engine.git'
	
	bundle install

# Install with
	gem install math_engine

The only dependency is on my other gem, [lexr](http://github.com/michaelbaldry/lexr), which is really lightweight and has no external dependencies.

	gem install lexr


# Latex parse
	In ruby
		require 'rubygems'
		require 'math_engine'
		engine = MathEngine.new
		
		puts "#{engine.parse_to_tex("(55 - 5) / (2.5 ^ (3 + 1))")
	
	results in an output of
		$ \frac{(55 -5)}{25.5 ^ (3 + 1)} $
		
	In rails 3
		It provide a helper methods calls tex and evaluate
		To use:

		<%= tex("(55 - 5) / (2.5 ^ (3 + 1))") %>
		<%= evaluate("(55 - 5) / (2.5 ^ (3 + 1))") %>


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

	engine.define :add_em do |x, y|
		x + y
	end

or you can write all your functions in a class and add the class

	class SomeFunctions
		def add_em(x, y)
			x + y
		end
	end

	engine.include_library SomeFunctions.new

and calling them with

	engine.evaluate("1 + 1 + add_em(2, 2)")

All functions are pulled in from the built in Math class by default, so all the standard ruby math functions are available (cos, sin, tan etc)

if you missed a closing parenthesis, had an operator where it wasn't meant to be, you might get something like this:

	Unexpected multiplication(*), expected: number, variable name or open_parenthesis

and that is pretty much every feature so far. Please let me know of any bugs or additions that you'd like to see

## Colaborator
  	Diego Marczal dmarczal@gmail.com

## Author of math_engie
	https://github.com/michaelbaldry/math_engine.git

## License

See the LICENSE file included with the distribution for licensing and
copyright details.
