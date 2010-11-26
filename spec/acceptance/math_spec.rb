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
	end
	
	it "should have the correct values when using variables" do
	  subject = MathEngine.new
	  subject.evaluate("x = 1 * 2").should == 2
	  subject.evaluate("x + 1").should == 3
  end
  
  it "should be able to call functions and use the result in calculations" do
    subject = MathEngine.new
    subject.define(:double_it, lambda { |x| x * 2 })
    subject.evaluate("10 * double_it(2)").should == 40
  end
end