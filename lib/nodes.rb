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

    def to_tex
      value
    end

  end

  class ExpressionNode < Node
    def evaluate(engine)
      left.evaluate(engine)
    end

    def parenthesis
      @parenthesis = true
    end

    def to_tex
      @parenthesis ? "(#{left.to_tex})" : left.to_tex
    end
  end

  class IdentifierNode < Node
    def evaluate(engine)
      engine.get value
    end

    def to_tex
      value
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

    def to_tex
      "#{left.to_tex} + #{right.to_tex}"
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

    def to_tex
      "#{left.to_tex} * #{right.to_tex}"
    end
  end
  class DivisionNode < Node
    def evaluate(engine)
      left.evaluate(engine) / right.evaluate(engine)
    end

    def to_tex
      "\frac{#{left.to_tex}}{#{right.to_tex}}"
    end
  end
  class ExponentNode < Node
    def evaluate(engine)
      left.evaluate(engine) ** right.evaluate(engine)
    end

    def to_tex
      if right.class == MathEngine::LiteralNumberNode &&
         left.class == MathEngine::LiteralNumberNode
        "#{left.to_tex} ^ #{right.to_tex}"
      elsif
        left.class == MathEngine::LiteralNumberNode &&
        right.class != MathEngine::LiteralNumberNode
           "#{left.to_tex} ^ {#{right.to_tex}}"
      elsif
        right.class == MathEngine::LiteralNumberNode &&
        left.class != MathEngine::LiteralNumberNode
        "{#{left.to_tex}} ^ #{right.to_tex}"
      else
        "{#{left.to_tex}} ^ {#{right.to_tex}}"
      end
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

    def to_tex
      "\\#{left} #{right.to_tex}"
    end
  end

  class ParametersNode < Node
    def evaluate(engine)
      left.evaluate(engine)
    end

    def to_a
      [left] + (right ? right.to_a : [])
    end

    def to_tex
      "#{parenthesis(left)}#{(right ? parenthesis(right) : '')}"
    end

    private
    def parenthesis(node)
      if node.class == LiteralNumberNode ||
         node.class == IdentifierNode
         node.to_tex
      else
        "(#{node.to_tex})"
      end
    end
  end
end
