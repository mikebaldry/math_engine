require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Parsing expressions" do
  it "should have the correct ast for simple addition" do
    subject = build_ast("1 + 2")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::AdditionNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(1)
    expect(subject.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.value).to eq(2)
  end

  it "should have the correct ast for stringed addition" do
    subject = build_ast("1 + 2 + 3")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::AdditionNode)
    expect(subject.left.left.class).to eq(MathEngine::AdditionNode)
    expect(subject.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.left.value).to eq(1)
    expect(subject.left.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.right.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.value).to eq(3)
  end

  it "should handle precedence of multiplication correctly" do
    subject = build_ast("10 * 2 - 3")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::SubtractionNode)
    expect(subject.left.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.left.value).to eq(10)
    expect(subject.left.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.right.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.value).to eq(3)
  end

  it "should handle precedence of division correctly" do
    subject = build_ast("10 / 2 - 3")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::SubtractionNode)
    expect(subject.left.left.class).to eq(MathEngine::DivisionNode)
    expect(subject.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.left.value).to eq(10)
    expect(subject.left.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.right.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.value).to eq(3)
  end

  it "should handle precedence of enclosed expressions" do
    subject = build_ast("10 * (2 + 3)")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(10)
    expect(subject.left.right.class).to eq(MathEngine::ParenthesisedExpressionNode)
    expect(subject.left.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.left.left.class).to eq(MathEngine::AdditionNode)
    expect(subject.left.right.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.left.value).to eq(2)
    expect(subject.left.right.left.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.right.value).to eq(3)
  end

  it "should handle assignment of expressions" do
    subject = build_ast("x = 10 * 10")
    expect(subject.class).to eq(MathEngine::AssignmentNode)
    expect(subject.left.class).to eq(MathEngine::IdentifierNode)
    expect(subject.left.value).to eq(:x)
    expect(subject.right.class).to eq(MathEngine::ExpressionNode)
    expect(subject.right.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.right.left.left.value).to eq(10)
    expect(subject.right.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.right.left.right.value).to eq(10)
  end

  it "should handle exponents" do
    subject = build_ast("1 ^ 5")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::ExponentNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(1)
    expect(subject.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.value).to eq(5)
  end

  it "should handle exponent precendence as higher than multiplication" do
    subject = build_ast("2 * 2 ^ 5")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    subject.left.left.value == 2
    expect(subject.left.right.class).to eq(MathEngine::ExponentNode)
    expect(subject.left.right.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.value).to eq(2)
    expect(subject.left.right.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.value).to eq(5)
  end

  it "should handle modulus precendence as higher than multiplication" do
    subject = build_ast("2 * 2 % 5")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    subject.left.left.value == 2
    expect(subject.left.right.class).to eq(MathEngine::ModulusNode)
    expect(subject.left.right.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.value).to eq(2)
    expect(subject.left.right.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.value).to eq(5)
  end

  it "should handle function calls with no parameters" do
    subject = build_ast("2 * sin()")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.right.left).to eq(:sin)
  end

  it "should handle function calls with 1 literal parameter" do
    subject = build_ast("2 * sin(2)")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.right.left).to eq(:sin)
    expect(subject.left.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.left.left.value).to eq(2)
  end

  it "should handle function calls with 2 literal parameter" do
    subject = build_ast("2 * something(1, 2)")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.right.left).to eq(:something)
    expect(subject.left.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.left.left.value).to eq(1)
    expect(subject.left.right.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.right.left.left.value).to eq(2)
  end

  it "should handle function calls with more literal parameter" do
    subject = build_ast("2 * something(1, 2, 3)")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(2)
    expect(subject.left.right.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.right.left).to eq(:something)
    expect(subject.left.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.left.left.value).to eq(1)
    expect(subject.left.right.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.right.left.left.value).to eq(2)
    expect(subject.left.right.right.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.right.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.right.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.right.right.right.left.left.value).to eq(3)
  end

  it "should handle function calls with 1 expression parameter" do
    subject = build_ast("sin(2 * 4)")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.left).to eq(:sin)
    expect(subject.left.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.left.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.right.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.left.value).to eq(2)
    expect(subject.left.right.left.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.right.value).to eq(4)
  end

  it "should handle nested function calls" do
    subject = build_ast("sin(2 * sin(4))")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.left).to eq(:sin)
    expect(subject.left.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.left.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.right.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.left.value).to eq(2)
    expect(subject.left.right.left.left.right.class).to eq(MathEngine::FunctionCallNode)
    expect(subject.left.right.left.left.right.left).to eq(:sin)
    expect(subject.left.right.left.left.right.right.class).to eq(MathEngine::ParametersNode)
    expect(subject.left.right.left.left.right.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.left.left.right.right.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.right.right.left.left.value).to eq(4)
  end

  it "should parse numbers correctly when no whitespace separates them (bug)" do
    subject = build_ast("10 * (2+3)")
    expect(subject.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.class).to eq(MathEngine::MultiplicationNode)
    expect(subject.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.left.value).to eq(10)
    expect(subject.left.right.class).to eq(MathEngine::ParenthesisedExpressionNode)
    expect(subject.left.right.left.class).to eq(MathEngine::ExpressionNode)
    expect(subject.left.right.left.left.class).to eq(MathEngine::AdditionNode)
    expect(subject.left.right.left.left.left.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.left.value).to eq(2)
    expect(subject.left.right.left.left.right.class).to eq(MathEngine::LiteralNumberNode)
    expect(subject.left.right.left.left.right.value).to eq(3)
  end
end

describe "Invalid syntax" do
  it "should raise an exception when an expression is incomplete" do
    expect { build_ast("1 *") }.to raise_error MathEngine::ParseError
  end

  it "should raise an exception when an extra operator is specified" do
    expect { build_ast("1 ** 2") }.to raise_error Lexr::UnmatchableTextError
  end

  it "should raise an exception when missing a closing parenthesis" do
    expect { build_ast("(((123))") }.to raise_error MathEngine::ParseError
  end

  it "should raise an exception when missing a parameter" do
    expect { build_ast("abc(1, )") }.to raise_error MathEngine::ParseError
  end
end
