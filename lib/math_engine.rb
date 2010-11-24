class MathEngine
  def evaluate(expression)
    MathParser.new(MathLexer.new(expression)).parse.evaluate
  end
end