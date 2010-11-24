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