require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Contextual scope for variables and functions" do
  it "should be able to set a variable and get it again" do
    subject = MathEngine::Context.new
    subject.set("test", "abc123")
    expect(subject.get("test")).to eq("abc123")
  end

  it "should be able to change a variable and get it again" do
    subject = MathEngine::Context.new
    subject.set("test", "abc123")
    subject.set("test", "abc12345")
    expect(subject.get("test")).to eq("abc12345")
  end

  it "should be able to set a constant (all uppercase) and get it again" do
    subject = MathEngine::Context.new
    subject.set("PI", 3.14159)
    expect(subject.get("PI")).to eq(3.14159)
  end

  it "should not be possible to set a constant (all uppercase) more than once" do
    subject = MathEngine::Context.new
    subject.set("PI", 3.14159)
    expect { subject.set("PI", 3.2) }.to raise_error MathEngine::UnableToModifyConstantError
  end

  it "should diferentiate between variables and constants" do
    subject = MathEngine::Context.new
    subject.set("blah", 123)
    subject.set("PI", 3.14159)
    expect(subject.variables).to eq(["blah"])
    expect(subject.constants).to eq(["PI"])
  end

  it "should raise an error if a function is called with the wrong number of arguments" do
    subject = MathEngine::Context.new
    subject.define :abc, lambda { |x, y, z| x + y + z }
    expect { subject.call(:abc, 123) }.to raise_error ArgumentError
  end

  it "should be possible to define a function with a lambda and call it" do
    subject = MathEngine::Context.new
    subject.define(:double_it, lambda { |x| x * 2 })
    expect(subject.call(:double_it, 2)).to eq(4)

    subject.define(:add_em, lambda { |x, y| x + y })
    expect(subject.call(:add_em, 2, 2)).to eq(4)
  end

  it "should be possible to define a function with a block and call it" do
    subject = MathEngine::Context.new
    subject.define :double_it do |x|
      x * 2
    end
    expect(subject.call(:double_it, 2)).to eq(4)

    subject.define :add_em do |x, y|
      x + y
    end
    expect(subject.call(:add_em, 2, 2)).to eq(4)
  end

  it "should be able to pull in a library and use its functions" do
    subject = MathEngine::Context.new

    Blah = Class.new do
      def test
        12345
      end
    end

    subject.include_library Blah.new
    expect(subject.call(:test)).to eq(12345)
  end

  it "should be able to pull in a library and use its functions, even if they are dynamic, via method_missing" do
    subject = MathEngine::Context.new

    Blah = Class.new do
      def method_missing(sym, *args, &block)
        return 12345 if sym == :test_12345
        raise NoMethodError(sym)
      end

      def respond_to_missing?(sym, include_private)
        sym == :test_12345
      end
    end

    subject.include_library Blah.new
    expect(subject.call(:test_12345)).to eq(12345)
  end

  it "should be able to use functions from Math by default" do
    subject = MathEngine::Context.new
    expect(subject.call(:sin, 0.5)).to be_within(0.001).of(0.4794255386)
  end
end

describe "Contextual scope for variables and functions with case sensetivity turned off" do
  it "should be able to set a variable and get it again" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("teSt", "abc123")
    expect(subject.get("test")).to eq("abc123")
  end

  it "should be able to change a variable and get it again" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("tesT", "abc123")
    subject.set("test", "abc12345")
    expect(subject.get("test")).to eq("abc12345")
  end

  it "should be able to set a constant (all uppercase) and get it again" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("PI", 3.14159)
    expect(subject.get("Pi")).to eq(3.14159)
  end

  it "should not be possible to set a constant (all uppercase) more than once" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("PI", 3.14159)
    expect { subject.set("Pi", 3.2) }.to raise_error MathEngine::UnableToModifyConstantError
  end

  it "should diferentiate between variables and constants" do
    subject = MathEngine::Context.new(case_sensitive: false)
    subject.set("blah", 123)
    subject.set("PI", 3.14159)
    expect(subject.variables).to eq(["blah"])
    expect(subject.constants).to eq(["PI"])
  end
end
