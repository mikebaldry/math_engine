require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Parsing expressions" do
	it "should have the correct ast for simple addition" do
		subject = build_ast("1 + 2")
		subject.class.should == MathParser::ExpressionNode
		subject.left.class.should == MathParser::AdditionNode
		subject.left.left.class.should == MathParser::LiteralNumberNode
		subject.left.left.value.should == 1
		subject.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.right.value.should == 2
	end
	
	it "should have the correct ast for stringed addition" do
		subject = build_ast("1 + 2 + 3")
		subject.class.should == MathParser::ExpressionNode
		subject.left.class.should == MathParser::AdditionNode
		subject.left.left.class.should == MathParser::AdditionNode
		subject.left.left.left.class.should == MathParser::LiteralNumberNode
		subject.left.left.left.value.should == 1
		subject.left.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.left.right.value.should == 2
		subject.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.right.value.should == 3
	end
	
	it "should handle precedence of multiplication correctly" do
    subject = build_ast("10 * 2 - 3")
    subject.class.should == MathParser::ExpressionNode
		subject.left.class.should == MathParser::SubtractionNode
		subject.left.left.class.should == MathParser::MultiplicationNode
		subject.left.left.left.class.should == MathParser::LiteralNumberNode
		subject.left.left.left.value.should == 10
		subject.left.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.left.right.value.should == 2
		subject.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.right.value.should == 3
  end
  
  it "should handle precedence of division correctly" do
    subject = build_ast("10 / 2 - 3")
    subject.class.should == MathParser::ExpressionNode
		subject.left.class.should == MathParser::SubtractionNode
		subject.left.left.class.should == MathParser::DivisionNode
		subject.left.left.left.class.should == MathParser::LiteralNumberNode
		subject.left.left.left.value.should == 10
		subject.left.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.left.right.value.should == 2
		subject.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.right.value.should == 3
  end
	
	it "should handle precedence of enclosed expressions" do
	  subject = build_ast("10 * (2 + 3)")
	  subject.class.should == MathParser::ExpressionNode
		subject.left.class.should == MathParser::MultiplicationNode
		subject.left.left.class.should == MathParser::LiteralNumberNode
		subject.left.left.value.should == 10
	  subject.left.right.class.should == MathParser::ExpressionNode
		subject.left.right.left.class.should == MathParser::AdditionNode
		subject.left.right.left.left.class.should == MathParser::LiteralNumberNode
		subject.left.right.left.left.value.should == 2
		subject.left.right.left.right.class.should == MathParser::LiteralNumberNode
		subject.left.right.left.right.value.should == 3
  end
  
  it "should handle assignment of expressions" do
    subject = build_ast("x = 10 * 10")
    subject.class.should == MathParser::AssignmentNode
    subject.left.class.should == MathParser::IdentifierNode
    subject.left.value.should == :x
    subject.right.class.should == MathParser::ExpressionNode
    subject.right.left.class.should == MathParser::MultiplicationNode
    subject.right.left.left.class.should == MathParser::LiteralNumberNode
    subject.right.left.left.value.should == 10
    subject.right.left.right.class.should == MathParser::LiteralNumberNode
    subject.right.left.right.value.should == 10
  end
end

describe "Invalid syntax" do
  it "should raise an exception when an expression is incomplete" do
    lambda { build_ast("1 *") }.should raise_error MathParser::ParseError
  end
  
  it "should raise an exception when an extra operator is specified" do
    lambda { build_ast("1 ** 2") }.should raise_error MathParser::ParseError
  end
  
  it "should raise an exception when missing a closing parenthesis" do
    lambda { build_ast("(((123))") }.should raise_error MathParser::ParseError
  end
end