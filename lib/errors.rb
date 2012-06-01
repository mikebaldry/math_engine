class MathEngine
  class ParseError < StandardError
    def initialize(message)
      @message = message
    end

    def to_s
      @message
    end
  end
  
  class UnknownVariableError < StandardError
    def initialize(variable_name)
      @variable_name = variable_name
    end

    def to_s
      "Variable '#{@variable_name}' was referenced but does not exist"
    end
  end
  
  class UnknownFunctionError < StandardError
    def initialize(function_name)
      @function_name = function_name
    end

    def to_s
      "Function '#{@function_name}' was referenced but does not exist"
    end
  end
  
  class UnableToModifyConstantError < StandardError
    def initialize(constant_name)
      @constant_name = constant_name
    end

    def to_s
      "Unable to modify value of constant '#{@constant_name}'"
    end
  end
  
  class UnknownEvaluatorError < StandardError
    def initialize(evaluator_name, expected_const)
      @evaluator_name = evaluator_name
      @expected_const = expected_const
    end
    
    def to_s
      "Unable to find an evaluator called #{@evaluator_name}(#{@expected_const})"
    end
    
    def ==(other)
      self.to_s == other.to_s
    end
  end
end