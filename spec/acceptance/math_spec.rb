require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Evaluating expressions" do
  it "should have the correct value for some simple calculations" do
    evaluate("1 + 1").should == 2
    evaluate("1+1").should == 2
    evaluate("1-1").should == 0
    evaluate("11+11").should == 22
    #evaluate("1--1").should == 2
    evaluate("2 - 1").should == 1
    evaluate("2 * 2").should == 4
    evaluate("4 / 2").should == 2
    evaluate("10 * 2 + 4").should == 24
    evaluate("10 * (2 + 4)").should == 60
    evaluate("10 + 10 + 10 + 10").should == 40
    evaluate("10 * 10 + 5 / 5").should == 101
    evaluate("3.14159 * (200 / 180) + 1").should be_within(4.49).of(0.001)
    evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * 2)").should == 70
    evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * (3 + 1))").should == 65
    evaluate("2 * 2 ^ 5").should == 64
    evaluate("(2 * 2) ^ 5").should == 1024
    evaluate("2 * 2 % 5").should == 4
    evaluate("2 * 4 / 3").should be_within(2.66666666666667).of(0.001)
  end

  it "should have the correct values when using variables" do
    subject = MathEngine::MathEngine.new
    subject.evaluate("x = 1 * 2").should == 2
    subject.evaluate("x + 1").should == 3
  end

  it "should be able to call functions and use the result in calculations" do
    subject = MathEngine::MathEngine.new
    subject.define(:double_it, lambda { |x| x * 2 })
    subject.define(:add_em, lambda { |x, y| x + y })
    subject.evaluate("10 * double_it(2)").should == 40
    subject.evaluate("10 * double_it(2 * 4 / 3)").should be_within(53.3333333334).of(0.001)
    subject.evaluate("10 * double_it(2 * 4 / 3 + (5 ^ 5))").should be_within(62553.333333).of(0.001)
    subject.evaluate("double_it(5) + add_em(10, add_em(2.5, 2.5)) + 5 + add_em(20, 20)").should == 70
  end
end

describe "Latex convert" do

  before(:each) do
    @engine = MathEngine::MathEngine.new
  end

  it "should convert a simple expression to latex" do
    @engine.parse_to_tex("1 + 2").should == "$1 + 2$"
  end

  it "should convert a expression with fraction to latex" do
    @engine.parse_to_tex("1 / 2").should == "$\\frac{1}{2}$"
  end

  it "should convert a expression with fraction with expression to latex" do
    @engine.parse_to_tex("1 / 2 + 3").should == "$\\frac{1}{2} + 3$"
    @engine.parse_to_tex("1 /(2 + 3)").should == "$\\frac{1}{(2 + 3)}$"
  end

  it "should convert a expression with fraction nested to latex" do
    @engine.parse_to_tex("1 / 2 / 3").should == "$\\frac{\\frac{1}{2}}{3}$"
  end

  it "should convert a expression with exponent to latex" do
    @engine.parse_to_tex("1 ^ 2 + 3").should == "$1 ^ 2 + 3$"
  end

  it "should convert a expression with exponent with expression latex" do
    @engine.parse_to_tex("1 ^ (2 + 3)").should == "$1 ^ {(2 + 3)}$"
    @engine.parse_to_tex("(2 + 2) ^ 2 + 3").should == "${(2 + 2)} ^ 2 + 3$"
    @engine.parse_to_tex("(2 + 2) ^ (2 + 3)").should == "${(2 + 2)} ^ {(2 + 3)}$"
    @engine.parse_to_tex("((2 + 2) * 1) ^ (2 + 3)").should == "${((2 + 2) * 1)} ^ {(2 + 3)}$"
  end

  it "should convert a expression with exponent nested to latex" do
    @engine.parse_to_tex("2 ^ 2 ^ 3").should == "${2 ^ 2} ^ 3$"
  end

  it "should convert a expression with sqrt function", :focus do
    @engine.define(:sqrt)
    @engine.parse_to_tex("sqrt(2)").should == "$\\sqrt 2$"
    @engine.parse_to_tex("sqrt(n)").should == "$\\sqrt n$"
    @engine.parse_to_tex("sqrt(2 + 2)").should == "$\\sqrt(2 + 2)$"
    @engine.parse_to_tex("sqrt(2 + (2 - 3))").should == "$\\sqrt(2 + (2 - 3))$"
    @engine.parse_to_tex("sqrt(2 ^ (2 + 3))").should == "$\\sqrt(2 ^ {(2 + 3)})$"
  end

end

