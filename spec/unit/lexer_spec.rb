require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Lexing expressions" do
  it "should have the correct tokens for simple addition" do
    subject = MathEngine::Lexer.new("1 + 1")
    expect(subject.next).to eq(Lexr::Token.number(1))
    expect(subject.next).to eq(Lexr::Token.addition('+'))
    expect(subject.next).to eq(Lexr::Token.number(1))
  end

  it "should have the correct tokens for simple addition without whitespace" do
    subject = MathEngine::Lexer.new("1+1")
    expect(subject.next).to eq(Lexr::Token.number(1))
    expect(subject.next).to eq(Lexr::Token.addition('+'))
    expect(subject.next).to eq(Lexr::Token.number(1))
  end

  it "should have the correct tokens for simple addition without whitespace" do
    subject = MathEngine::Lexer.new("-10*(-3--2)")
    expect(subject.next).to eq(Lexr::Token.number(-10))
    expect(subject.next).to eq(Lexr::Token.multiplication("*"))

    expect(subject.next).to eq(Lexr::Token.open_parenthesis("("))
    expect(subject.next).to eq(Lexr::Token.number(-3))
    expect(subject.next).to eq(Lexr::Token.subtraction("-"))
    expect(subject.next).to eq(Lexr::Token.number(-2))
    expect(subject.next).to eq(Lexr::Token.close_parenthesis(")"))

    expect(subject.next).to eq(Lexr::Token.end)
  end

  it "should do this expression properly" do
    subject = MathEngine::Lexer.new("(3+2)-2")

    expect(subject.next).to eq(Lexr::Token.open_parenthesis("("))
    expect(subject.next).to eq(Lexr::Token.number(3))
    expect(subject.next).to eq(Lexr::Token.addition("+"))
    expect(subject.next).to eq(Lexr::Token.number(2))
    expect(subject.next).to eq(Lexr::Token.close_parenthesis(")"))

    expect(subject.next).to eq(Lexr::Token.subtraction("-"))
    expect(subject.next).to eq(Lexr::Token.number(2))

    expect(subject.next).to eq(Lexr::Token.end)
  end
end
