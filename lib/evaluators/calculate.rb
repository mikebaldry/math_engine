class MathEngine
  module Evaluators
    class Calculate
      def initialize(context)
        @context = context
      end
    
      def literal_number(node)
        node.value
      end
    
      def expression(node)
        node.left.evaluate(self)
      end
    
      def identifier(node)
        @context.get node.value
      end
    
      def assignment(node)
        result = node.right.evaluate(self)
        @context.set(node.left.value, result)
        result
      end
    
      def addition(node)
        node.left.evaluate(self) + node.right.evaluate(self)
      end
    
      def subtraction(node)
        node.left.evaluate(self) - node.right.evaluate(self)
      end
    
      def multiplication(node)
        node.left.evaluate(self) * node.right.evaluate(self)
      end

      def division(node)
        node.left.evaluate(self) / node.right.evaluate(self)
      end

      def exponent(node)
        node.left.evaluate(self) ** node.right.evaluate(self)
      end
    
      def modulus(node)
        node.left.evaluate(self) % node.right.evaluate(self)
      end

      def function_call(node)
        parameters = node.right ? node.right.to_a.collect { |p| p.evaluate(self) } : []
        @context.call(node.left, *parameters)
      end
    
      def parameters(node)
        node.left.evaluate(self)
      end
    end
  end
end