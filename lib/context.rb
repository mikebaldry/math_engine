class MathEngine
  class Context
    DEFAULT_OPTIONS = {case_sensitive: true}
    
    def initialize(opts = {})
      @opts = DEFAULT_OPTIONS.merge(opts)
      @variables = {}
      @dynamic_library = Class.new.new
      @libraries = [@dynamic_library, Math]
    end
    
    def get(variable_name)
      @variables[key variable_name]
    end
    
    def set(variable_name, value)
      raise MathEngine::UnableToModifyConstantError.new(key variable_name) if constant?(key variable_name) && 
                                                                              get(variable_name)
                                                                              
      @variables[key variable_name] = value
    end
    
    def define(function_name, func = nil, &block)
      @dynamic_library.class.send :define_method, function_name.to_sym do |*args|
        func ? func.call(*args) : block.call(*args)
      end
    end
    
    def call(function_name, *args)
      library = library_for_function(function_name)
      raise UnknownFunctionError.new(function_name) unless library
      library.send(function_name, *args)
    end
    
    def include_library(library)
      @libraries << library
    end
    
    def constants
      @variables.keys.select { |variable_name| constant?(variable_name) }
    end
    
    def variables
      @variables.keys - constants
    end
    
    private
    
    def constant?(variable_name)
      variable_name.upcase == variable_name
    end
    
    def key(variable_name)
      return variable_name if @opts[:case_sensitive]
      result = @variables.keys.select { |key| key.downcase == variable_name.downcase }.first
      result || variable_name
    end
    
    def library_for_function(function_name)
      @libraries.detect { |l| l.methods.include? function_name.to_sym }
    end
  end
end