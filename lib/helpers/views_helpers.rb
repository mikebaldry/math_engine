require File.expand_path(File.join(File.dirname(__FILE__), "../" ,  'math_engine'))

module MathEngine
  module ViewsHelpers
    def tex(exp)
      engine = MathEngine.new
      engine.parse_to_tex(exp)
    end

    def evaluate(exp)
      engine = MathEngine.new
      engine.evaluate(exp)
    end
  end
end