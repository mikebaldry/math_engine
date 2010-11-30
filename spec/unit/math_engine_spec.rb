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
  
  it "should raise an error when trying to set an constant that is already defined" do
    subject = MathEngine.new
    subject.set(:PI, 3.14159)
    lambda { subject.set(:PI, 3.14159) }.should raise_error MathEngine::UnableToModifyConstant
  end
end

describe "Calling functions" do
  it "should raise an error if a function hasn't been defined but is called" do
    subject = MathEngine.new
    lambda { subject.call(:this_function_dont_exist) }.should raise_error MathEngine::UnknownFunctionError
  end
  
  it "should raise an error if a function is called with the wrong number of arguments" do
    subject = MathEngine.new
    subject.define :abc, lambda { |x, y, z| x + y + z }
    lambda { subject.call(:abc, 123) }.should raise_error MathEngine::ArgumentCountError
  end
  
  it "should be possible to define a function with a lambda and call it" do
    subject = MathEngine.new
    subject.define(:double_it, lambda { |x| x * 2 })
    subject.call(:double_it, 2).should == 4

    subject.define(:add_em, lambda { |x, y| x + y })
    subject.call(:add_em, 2, 2).should == 4
  end
  
  it "should be possible to define a function with a block and call it" do
    subject = MathEngine.new
    subject.define :double_it do |x|
      x * 2
    end
    subject.call(:double_it, 2).should == 4
    
    subject.define :add_em do |x, y|
      x + y
    end
    subject.call(:add_em, 2, 2).should == 4
  end
end