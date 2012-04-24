require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Getting and setting variables" do

  before(:each) do
    @subject = MathEngine::MathEngine.new
  end

  it "should be able to set a variable and get it again" do
    @subject.set(:blah, 123)
    @subject.get(:blah).should == 123
  end

  it "should raise an error if a variable isn't gettable" do
    lambda { @subject.get(:abc) }.should raise_error MathEngine::MathEngine::UnknownVariableError
  end

  it "should return a list of variable names that are defined" do
    @subject.set(:blah, 123)
    @subject.set(:abc, 10)
    @subject.variables.should == [:abc, :blah]
  end

  it "should diferentiate between variables and constants" do
    @subject.set(:blah, 123)
    @subject.set(:PI, 3.14159)
    @subject.variables.should == [:blah]
    @subject.constants.should == [:PI]
  end

  it "should raise an error when trying to set an constant that is already defined" do
    @subject.set(:PI, 3.14159)
    lambda { @subject.set(:PI, 3.14159) }.should raise_error MathEngine::MathEngine::UnableToModifyConstant
  end
end

describe "Calling functions" do
  before(:each) do
    @subject = MathEngine::MathEngine.new
  end

  it "should raise an error if a function hasn't been defined but is called" do
    lambda { @subject.call(:this_function_dont_exist) }.should raise_error MathEngine::MathEngine::UnknownFunctionError
  end

  it "should raise an error if a function is called with the wrong number of arguments" do
    @subject.define :abc, lambda { |x, y, z| x + y + z }
    lambda { @subject.call(:abc, 123) }.should raise_error ArgumentError
  end

  it "should be possible to define a function with a lambda and call it" do
    @subject.define(:double_it, lambda { |x| x * 2 })
    @subject.call(:double_it, 2).should == 4

    @subject.define(:add_em, lambda { |x, y| x + y })
    @subject.call(:add_em, 2, 2).should == 4
  end

  it "should be possible to define a function with a block and call it" do
    @subject.define :double_it do |x|
      x * 2
    end
    @subject.call(:double_it, 2).should == 4

    @subject.define :add_em do |x, y|
      x + y
    end
    @subject.call(:add_em, 2, 2).should == 4
  end

  it "should be able to pull in a library and use its functions" do

    Blah = Class.new do
      def test
        12345
      end
    end

    @subject.include_library Blah.new
    @subject.evaluate("test()").should == 12345
  end

  it "should be able to use functions from Math by default" do
    @subject.evaluate("sin(0.5)").should be_within(0.4794255386).of(0.001)
  end
end
