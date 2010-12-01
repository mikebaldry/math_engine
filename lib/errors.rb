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
  
  class UnableToModifyConstant < StandardError
    def initialize(constant_name)
      @constant_name = constant_name
    end

    def to_s
      "Unable to modify value of constant '#{@constant_name}'"
    end
  end
  
  class ArgumentCountError < StandardError
    def initialize(function_name, arguments_taken, arguments_called_with)
      @function_name = function_name
      @arguments_taken, @arguments_called_with = arguments_taken, arguments_called_with
    end
  
    def to_s
      "Function '#{@function_name}' takes #{@arguments_taken} but was called with #{@arguments_called_with}"
    end
  end
end