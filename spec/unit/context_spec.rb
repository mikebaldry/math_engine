require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Contextual scope for variables and functions" do
  it "should be able to set a variable and get it again" do
    subject = MathEngine::Context.new
    subject.set("test", "abc123")
    subject.get("test").should == "abc123"
  end
  
  it "should be able to change a variable and get it again" do
    subject = MathEngine::Context.new
    subject.set("test", "abc123")
    subject.set("test", "abc12345")
    subject.get("test").should == "abc12345"
  end
  
  it "should be able to set a constant (all uppercase) and get it again" do
    subject = MathEngine::Context.new
    subject.set("PI", 3.14159)
    subject.get("PI").should == 3.14159
  end
  
  it "should not be possible to set a constant (all uppercase) more than once" do
    subject = MathEngine::Context.new
    subject.set("PI", 3.14159)
    lambda { subject.set("PI", 3.2) }.should raise_error MathEngine::UnableToModifyConstantError
  end
  
  it "should diferentiate between variables and constants" do
    subject = MathEngine::Context.new
    subject.set("blah", 123)
    subject.set("PI", 3.14159)
    subject.variables.should == ["blah"]
    subject.constants.should == ["PI"]
  end
  
  it "should raise an error if a function is called with the wrong number of arguments" do
    subject = MathEngine::Context.new
    subject.define :abc, lambda { |x, y, z| x + y + z }
    lambda { subject.call(:abc, 123) }.should raise_error ArgumentError
  end
  
  it "should be possible to define a function with a lambda and call it" do
    subject = MathEngine::Context.new
    subject.define(:double_it, lambda { |x| x * 2 })
    subject.call(:double_it, 2).should == 4

    subject.define(:add_em, lambda { |x, y| x + y })
    subject.call(:add_em, 2, 2).should == 4
  end
  
  it "should be possible to define a function with a block and call it" do
    subject = MathEngine::Context.new
    subject.define :double_it do |x|
      x * 2
    end
    subject.call(:double_it, 2).should == 4
    
    subject.define :add_em do |x, y|
      x + y
    end
    subject.call(:add_em, 2, 2).should == 4
  end
  
  it "should be able to pull in a library and use its functions" do
    subject = MathEngine::Context.new
    
    Blah = Class.new do
      def test
        12345
      end
    end
    
    subject.include_library Blah.new
    subject.call(:test).should == 12345
  end
  
  it "should be able to use functions from Math by default" do
    subject = MathEngine::Context.new
    subject.call(:sin, 0.5).should be_close 0.4794255386, 0.001
  end
end

describe "Contextual scope for variables and functions with case sensetivity turned off" do
  it "should be able to set a variable and get it again" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("teSt", "abc123")
    subject.get("test").should == "abc123"
  end
  
  it "should be able to change a variable and get it again" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("tesT", "abc123")
    subject.set("test", "abc12345")
    subject.get("test").should == "abc12345"
  end
  
  it "should be able to set a constant (all uppercase) and get it again" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("PI", 3.14159)
    subject.get("Pi").should == 3.14159
  end
  
  it "should not be possible to set a constant (all uppercase) more than once" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("PI", 3.14159)
    lambda { subject.set("Pi", 3.2) }.should raise_error MathEngine::UnableToModifyConstantError
  end
  
  it "should diferentiate between variables and constants" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("blah", 123)
    subject.set("PI", 3.14159)
    subject.variables.should == ["blah"]
    subject.constants.should == ["PI"]
  end
end