require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Parsing expressions" do
  it "should have the correct ast for simple addition" do
    subject = build_ast("1 + 2")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::AdditionNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 1
    subject.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.value.should == 2
  end
  
  it "should have the correct ast for stringed addition" do
    subject = build_ast("1 + 2 + 3")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::AdditionNode
    subject.left.left.class.should == MathEngine::AdditionNode
    subject.left.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.left.value.should == 1
    subject.left.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.left.right.value.should == 2
    subject.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.value.should == 3
  end
  
  it "should handle precedence of multiplication correctly" do
    subject = build_ast("10 * 2 - 3")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::SubtractionNode
    subject.left.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.left.value.should == 10
    subject.left.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.left.right.value.should == 2
    subject.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.value.should == 3
  end
  
  it "should handle precedence of division correctly" do
    subject = build_ast("10 / 2 - 3")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::SubtractionNode
    subject.left.left.class.should == MathEngine::DivisionNode
    subject.left.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.left.value.should == 10
    subject.left.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.left.right.value.should == 2
    subject.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.value.should == 3
  end
  
  it "should handle precedence of enclosed expressions" do
    subject = build_ast("10 * (2 + 3)")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 10
    subject.left.right.class.should == MathEngine::ExpressionNode
    subject.left.right.left.class.should == MathEngine::AdditionNode
    subject.left.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.left.value.should == 2
    subject.left.right.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.right.value.should == 3
  end
  
  it "should handle assignment of expressions" do
    subject = build_ast("x = 10 * 10")
    subject.class.should == MathEngine::AssignmentNode
    subject.left.class.should == MathEngine::IdentifierNode
    subject.left.value.should == :x
    subject.right.class.should == MathEngine::ExpressionNode
    subject.right.left.class.should == MathEngine::MultiplicationNode
    subject.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.right.left.left.value.should == 10
    subject.right.left.right.class.should == MathEngine::LiteralNumberNode
    subject.right.left.right.value.should == 10
  end
  
  it "should handle exponents" do
    subject = build_ast("1 ^ 5")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::ExponentNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 1
    subject.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.value.should == 5
  end
  
  it "should handle exponent precendence as higher than multiplication" do
    subject = build_ast("2 * 2 ^ 5")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value == 2
    subject.left.right.class.should == MathEngine::ExponentNode
    subject.left.right.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.value.should == 2
    subject.left.right.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.value.should == 5
  end
  
  it "should handle modulus precendence as higher than multiplication" do
    subject = build_ast("2 * 2 % 5")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value == 2
    subject.left.right.class.should == MathEngine::ModulusNode
    subject.left.right.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.value.should == 2
    subject.left.right.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.value.should == 5
  end
  
  it "should handle function calls with no parameters" do
    subject = build_ast("2 * sin()")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 2
    subject.left.right.class.should == MathEngine::FunctionCallNode
    subject.left.right.left.should == :sin
  end
  
  it "should handle function calls with 1 literal parameter" do
    subject = build_ast("2 * sin(2)")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 2
    subject.left.right.class.should == MathEngine::FunctionCallNode
    subject.left.right.left.should == :sin
    subject.left.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.left.left.value.should == 2
  end
  
  it "should handle function calls with 2 literal parameter" do
    subject = build_ast("2 * something(1, 2)")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 2
    subject.left.right.class.should == MathEngine::FunctionCallNode
    subject.left.right.left.should == :something
    subject.left.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.left.left.value.should == 1
    subject.left.right.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.right.left.left.value.should == 2
  end
  
  it "should handle function calls with more literal parameter" do
    subject = build_ast("2 * something(1, 2, 3)")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 2
    subject.left.right.class.should == MathEngine::FunctionCallNode
    subject.left.right.left.should == :something
    subject.left.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.left.left.value.should == 1
    subject.left.right.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.right.left.left.value.should == 2
    subject.left.right.right.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.right.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.right.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.right.right.right.left.left.value.should == 3
  end
  
  it "should handle function calls with 1 expression parameter" do
    subject = build_ast("sin(2 * 4)")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::FunctionCallNode
    subject.left.left.should == :sin
    subject.left.right.class.should == MathEngine::ParametersNode
    subject.left.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.left.left.class.should == MathEngine::MultiplicationNode
    subject.left.right.left.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.left.left.value.should == 2
    subject.left.right.left.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.left.right.value.should == 4
  end
  
  it "should handle nested function calls" do
    subject = build_ast("sin(2 * sin(4))")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::FunctionCallNode
    subject.left.left.should == :sin
    subject.left.right.class.should == MathEngine::ParametersNode
    subject.left.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.left.left.class.should == MathEngine::MultiplicationNode
    subject.left.right.left.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.left.left.value.should == 2
    subject.left.right.left.left.right.class.should == MathEngine::FunctionCallNode
    subject.left.right.left.left.right.left.should == :sin
    subject.left.right.left.left.right.right.class.should == MathEngine::ParametersNode
    subject.left.right.left.left.right.right.left.class.should == MathEngine::ExpressionNode
    subject.left.right.left.left.right.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.left.right.right.left.left.value.should == 4
  end
  
  it "should parse numbers correctly when no whitespace separates them (bug)" do
    subject = build_ast("10 * (2+3)")
    subject.class.should == MathEngine::ExpressionNode
    subject.left.class.should == MathEngine::MultiplicationNode
    subject.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.left.value.should == 10
    subject.left.right.class.should == MathEngine::ExpressionNode
    subject.left.right.left.class.should == MathEngine::AdditionNode
    subject.left.right.left.left.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.left.value.should == 2
    subject.left.right.left.right.class.should == MathEngine::LiteralNumberNode
    subject.left.right.left.right.value.should == 3
  end
end

describe "Invalid syntax" do
  it "should raise an exception when an expression is incomplete" do
    lambda { build_ast("1 *") }.should raise_error MathEngine::ParseError
  end
  
  it "should raise an exception when an extra operator is specified" do
    lambda { build_ast("1 ** 2") }.should raise_error Lexr::UnmatchableTextError
  end
  
  it "should raise an exception when missing a closing parenthesis" do
    lambda { build_ast("(((123))") }.should raise_error MathEngine::ParseError
  end
  
  it "should raise an exception when missing a parameter" do
    lambda { build_ast("abc(1, )") }.should raise_error MathEngine::ParseError
  end
end