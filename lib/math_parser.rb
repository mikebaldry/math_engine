class MathParser
	def initialize(lexer)
		@lexer = lexer
	end
	
	def parse
		#statement = expression <end>
		#expression = term { ( <addition> | <subtraction> ) term } 
		#term = factor { ( <multiplication> | <division> ) factor }
		#factor = <number> | <open_parenthesis> expression <close_parenthesis>
		statement
	end
	
	private
	
	def statement
	  next!
		result = expression
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
		left = factor
		result = nil
		while [:multiplication, :division].include? current.type
			node_type = current.type == :multiplication ? MultiplicationNode : DivisionNode
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
	  end
		expect_current :open_parenthesis, "number or open_parenthesis"
		next!
		result = expression
		expect_current :close_parenthesis
		next!
		result
	end
	
	private
	
	def current
	  @lexer.current
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

			def evaluate
				raise "Evaluate not overridden in #{self.class.name}"
			end
		end

		class LiteralNumberNode < Node
			def evaluate
				value
			end
		end

		class ExpressionNode < Node
			def evaluate
				left.evaluate
			end
		end

		class AdditionNode < Node
			def evaluate
				left.evaluate + right.evaluate
			end
		end

		class SubtractionNode < Node
			def evaluate
				left.evaluate - right.evaluate
			end
		end
		class MultiplicationNode < Node
			def evaluate
				left.evaluate * right.evaluate
			end
		end
		class DivisionNode < Node
			def evaluate
				left.evaluate / right.evaluate
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