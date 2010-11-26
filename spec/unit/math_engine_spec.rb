require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Getting and setting variables" do
	it "should be able to set a variable and get it again" do
		subject = MathEngine.new
		subject.set(:blah, 123)
		subject.get(:blah).should == 123
	end
	
	it "should raise an error if a variable isn't gettable" do
	  subject = MathEngine.new
	  lambda { subject.get(:abc) }.should raise_error MathEngine::UnknownVariableError
  end
  
  it "should return a list of variable names that are defined" do
    subject = MathEngine.new
    subject.set(:blah, 123)
    subject.set(:abc, 10)
    
    subject.variables.should == [:abc, :blah]
  end
end

describe "Calling functions" do
  it "should raise an error if a function hasn't been defined but is called" do
    subject = MathEngine.new
    lambda { subject.call(:this_function_dont_exist) }.should raise_error MathEngine::UnknownFunctionError
  end
  
  it "should be possible to define a function and call it" do
    subject = MathEngine.new
    subject.define(:double_it, lambda { |x| x * 2 })
    subject.call(:double_it, 2).should == 4

    subject.define(:add_em, lambda { |x, y| x + y })
    subject.call(:add_em, 2, 2).should == 4
  end
end