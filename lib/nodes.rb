class MathEngine
  class Node
    attr_reader :left, :right
    alias :value :left

    def initialize(left, right = nil)
      @left, @right = left, right
    end
    
    def evaluate(evaluator)
      evaluator.send(method_name, self)
    end
    
    private
    
    def method_name
      class_name = self.class.name[0..-5]
      class_name = class_name[class_name.rindex("::")+2..-1] if class_name.rindex("::")
      method_name = class_name.gsub(%r{([A-Z\d]+)([A-Z][a-z])},'\1_\2').gsub(%r{([a-z\d])([A-Z])},'\1_\2').downcase  
    end
  end

  class LiteralNumberNode < Node ; end
  class ExpressionNode < Node ; end
  class IdentifierNode < Node ; end
  class AssignmentNode < Node ; end

  class AdditionNode < Node ; end
  class SubtractionNode < Node ; end
  class MultiplicationNode < Node ; end
  class DivisionNode < Node ; end
  class ExponentNode < Node ; end
  class ModulusNode < Node ; end

  class FunctionCallNode < Node ; end

  class ParametersNode < Node
    def to_a
      [left] + (right ? right.to_a : [])
    end
  end
end