require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Evaluating expressions" do
  it "should have the correct value for some simple calculations" do
    evaluate("1 + 1").should == 2
    evaluate("2 - 1").should == 1
    evaluate("2 * 2").should == 4
    evaluate("4 / 2").should == 2
    evaluate("10 * 2 + 4").should == 24
    evaluate("10 * (2 + 4)").should == 60
    evaluate("10 + 10 + 10 + 10").should == 40
    evaluate("10 * 10 + 5 / 5").should == 101
    evaluate("3.14159 * (200 / 180) + 1").should be_close 4.49, 0.001
    evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * 2)").should == 70
    evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * (3 + 1))").should == 65
    evaluate("2 * 2 ^ 5").should == 64
    evaluate("(2 * 2) ^ 5").should == 1024
    evaluate("2 * 2 % 5").should == 4
    evaluate("2 * 4 / 3").should be_close 2.66666666666667, 0.001
  end
  
  it "should have the correct values when using variables" do
    subject = MathEngine.new
    subject.evaluate("x = 1 * 2").should == 2
    subject.evaluate("x + 1").should == 3
  end
  
  it "should be able to call functions and use the result in calculations" do
    subject = MathEngine.new
    subject.context.define(:double_it, lambda { |x| x * 2 })
    subject.context.define(:add_em, lambda { |x, y| x + y })
    subject.evaluate("10 * double_it(2)").should == 40
    subject.evaluate("10 * double_it(2 * 4 / 3)").should be_close 53.3333333334, 0.001
    subject.evaluate("10 * double_it(2 * 4 / 3 + (5 ^ 5))").should be_close 62553.333333, 0.001
    subject.evaluate("double_it(5) + add_em(10, add_em(2.5, 2.5)) + 5 + add_em(20, 20)").should == 70
  end
end