class MathParser
	def initialize(lexer)
		@lexer = lexer
	end
	
	def parse
		#statement = { <identifier> <assignment> } expression <end>
		#expression = term { ( <addition> | <subtraction> ) term }
		#term = exp { ( <multiplication> | <division> ) exp }
		#exp = factor { ( <exponent> | <modulus> ) factor }
		#factor = <call> | <identifier> | <number> | ( <open_parenthesis> expression <close_parenthesis> )
    #call = <identifier> <open_parenthesis> { call_parameter_list } <close_parenthesis>
    #call_parameter_list = call_parameter | ( call_parameter_list <comma> call_parameter )
    #call_parameter = <identifier>
		statement
	end
	
	private
	
	def statement
	  next!
	  if current.type == :identifier && peek.type == :assignment
	    variable_name = current.value
	    next!
	    expect_current :assignment
	    next!
	    result = AssignmentNode.new(IdentifierNode.new(variable_name), expression)
	  else 
		  result = expression
		end
		next!
		expect_current :end
		result
	end
	
	def expression
		left = term
		result = nil
		while [:addition, :subtraction].include? current.type
			node_type = current.type == :addition ? AdditionNode : SubtractionNode
			next!
			left = node_type.new(left, term)
		end
		ExpressionNode.new(result || left)
	end
	
	def term
		left = exp
		result = nil
		while [:multiplication, :division].include? current.type
			node_type = current.type == :multiplication ? MultiplicationNode : DivisionNode
			next!
			left = node_type.new(left, exp)
		end
		result || left
	end
	
	def exp
	  left = factor
		result = nil
		while [:exponent, :modulus].include? current.type
			node_type = current.type == :exponent ? ExponentNode : ModulusNode
			next!
			left = node_type.new(left, factor)
		end
		result || left
  end
	
	def factor
	  if current.type == :number
	    result = LiteralNumberNode.new(current.value)
	    next!
	    return result
	  elsif current.type == :identifier
	    if peek.type == :open_parenthesis
	      result = call
	    else
	      result = IdentifierNode.new(current.value)
      end
      next!
      return result
    end
    
		expect_current :open_parenthesis, "number, variable or open_parenthesis"
		next!
		result = expression
		expect_current :close_parenthesis
		next!
		result
	end
	
	#call = <identifier> <open_parenthesis> { call_parameter_list } <close_parenthesis>
  #call_parameter_list = call_parameter | ( call_parameter_list <comma> call_parameter )
  #call_parameter = <identifier>
	
	def call
	  expect_current :identifier
	  function_name = current.value
	  next!
	  expect_current :open_parenthesis
	  next!
	  result = FunctionCallNode.new(function_name, current.type == :close_parenthesis ? nil : call_parameter)
	  expect_current :close_parenthesis
	  next!
	  result
  end
  
  def call_parameter
    left = expression
    right = nil
    if current.type == :comma
      next!
      right = call_parameter
    end
    ParametersNode.new(left, right)
  end
	
	private
	
	def current
	  @lexer.current
  end
  
  def peek
    @lexer.peek
  end
	
	def next!
		@lexer.next
	end
	
	def expect_current(type, friendly = nil)
	  raise ParseError.new("Unexpected #{current}, expected: #{friendly ? friendly : type}") unless current.type == type
  end
	
	class Node
			attr_reader :left, :right
			alias :value :left

			def initialize(left, right = nil)
				@left, @right = left, right
			end

			def evaluate(engine)
				raise "Evaluate not overridden in #{self.class.name}"
			end
		end

		class LiteralNumberNode < Node
			def evaluate(engine)
				value
			end
		end

		class ExpressionNode < Node
			def evaluate(engine)
				left.evaluate(engine)
			end
		end
		
		class IdentifierNode < Node
		  def evaluate(engine)
		    engine.get value
	    end
	  end

		class AssignmentNode < Node
			def evaluate(engine)
				result = right.evaluate(engine)
				engine.set(left.value, result)
				result
			end
		end

		class AdditionNode < Node
			def evaluate(engine)
				left.evaluate(engine) + right.evaluate(engine)
			end
		end

		class SubtractionNode < Node
			def evaluate(engine)
				left.evaluate(engine) - right.evaluate(engine)
			end
		end
		class MultiplicationNode < Node
			def evaluate(engine)
			  left.evaluate(engine) * right.evaluate(engine)
			end
		end
		class DivisionNode < Node
			def evaluate(engine)
				left.evaluate(engine) / right.evaluate(engine)
			end
		end
		class ExponentNode < Node
			def evaluate(engine)
				left.evaluate(engine) ** right.evaluate(engine)
			end
		end
		class ModulusNode < Node
		  def evaluate(engine)
		    left.evaluate(engine) % right.evaluate(engine)
	    end
	  end
	  
	  class FunctionCallNode < Node
	    def evaluate(engine)
	      parameters = right ? right.to_a.collect { |p| p.evaluate(engine) } : []
	      engine.call(left, *parameters)
      end
    end
    
    class ParametersNode < Node
	    def evaluate(engine)
	      left.evaluate(engine)
      end
      
      def to_a
        [left]
      end
    end

	  class ParseError < StandardError
	    def initialize(message)
	      @message = message
      end
      
      def to_s
        @message
      end
    end
end