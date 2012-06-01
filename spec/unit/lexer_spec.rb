require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Lexing expressions" do
  it "should have the correct tokens for simple addition" do
    subject = MathEngine::Lexer.new("1 + 1")
    subject.next.should == Lexr::Token.number(1)
    subject.next.should == Lexr::Token.addition('+')
    subject.next.should == Lexr::Token.number(1)
  end
  
  it "should have the correct tokens for simple addition without whitespace" do
    subject = MathEngine::Lexer.new("1+1")
    subject.next.should == Lexr::Token.number(1)
    subject.next.should == Lexr::Token.addition('+')
    subject.next.should == Lexr::Token.number(1)
  end
  
  it "should have the correct tokens for simple addition without whitespace" do
    subject = MathEngine::Lexer.new("-10*(-3--2)")
    subject.next.should == Lexr::Token.number(-10)
    subject.next.should == Lexr::Token.multiplication("*")
    
    subject.next.should == Lexr::Token.open_parenthesis("(")
    subject.next.should == Lexr::Token.number(-3)
    subject.next.should == Lexr::Token.subtraction("-")
    subject.next.should == Lexr::Token.number(-2)
    subject.next.should == Lexr::Token.close_parenthesis(")")

    subject.next.should == Lexr::Token.end
  end
  
  it "should do this expression properly" do
    subject = MathEngine::Lexer.new("(3+2)-2")
  
    subject.next.should == Lexr::Token.open_parenthesis("(")
    subject.next.should == Lexr::Token.number(3)
    subject.next.should == Lexr::Token.addition("+")
    subject.next.should == Lexr::Token.number(2)
    subject.next.should == Lexr::Token.close_parenthesis(")")

    subject.next.should == Lexr::Token.subtraction("-")
    subject.next.should == Lexr::Token.number(2)

    subject.next.should == Lexr::Token.end
  end
end