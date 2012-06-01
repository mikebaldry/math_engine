require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Lexing expressions" do
  it "should have the correct ast for simple addition" do
    subject = MathEngine::Lexer.new("1 + 1")
    subject.next.should == Lexr::Token.new(1, :number)
    subject.next.should == Lexr::Token.new('+', :addition)
    subject.next.should == Lexr::Token.new(1, :number)
  end
  
  it "should have the correct ast for simple addition without whitespace" do
    subject = MathEngine::Lexer.new("1+1")
    subject.next.should == Lexr::Token.new(1, :number)
    subject.next.should == Lexr::Token.new('+', :addition)
    subject.next.should == Lexr::Token.new(1, :number)
  end
end