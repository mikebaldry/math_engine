class MathEngine
  class Node
	  attr_reader :left, :right
  	alias :value :left

  	def initialize(left, right = nil)
  		@left, @right = left, right
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
      [left] + (right ? right.to_a : [])
    end
  end
end