#require "mathn"
require "bigdecimal"

require_relative "errors"
require_relative "lexer"
require_relative "parser"
require_relative "context"

require_relative "evaluators/finders"
require_relative "evaluators/calculate"

class MathEngine
  DEFAULT_OPTIONS = {evaluator: :calculate,
                     case_sensitive: true}
  
  def initialize(opts = {})
    @opts = DEFAULT_OPTIONS.merge(opts)
    @opts[:context] = Context.new(@opts) unless @opts[:context]
  end
  
  def evaluate(expression)
    evaluator = MathEngine::Evaluators.find_by_name(@opts[:evaluator]).new(context)
    Parser.new(Lexer.new(expression)).parse.evaluate(evaluator)
  end
  
  def context
    @opts[:context]
  end
end
