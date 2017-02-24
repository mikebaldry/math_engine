require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Evaluating expressions" do
  it "should have the correct value for some simple calculations" do
    expect(evaluate("1 + 1")).to eq(2)
    expect(evaluate("2 - 1")).to eq(1)
    expect(evaluate("2 * 2")).to eq(4)
    expect(evaluate("4 / 2")).to eq(2)
    expect(evaluate("10 * 2 + 4")).to eq(24)
    expect(evaluate("10 * (2 + 4)")).to eq(60)
    expect(evaluate("10 + 10 + 10 + 10")).to eq(40)
    expect(evaluate("10 * 10 + 5 / 5")).to eq(101)
    expect(evaluate("3.14159 * (200 / 180) + 1")).to be_within(0.001).of(4.49)
    expect(evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * 2)")).to eq(70)
    expect(evaluate("10 * (3 * 2) + (55 - 5) / (2.5 * (3 + 1))")).to eq(65)
    expect(evaluate("2 * 2 ^ 5")).to eq(64)
    expect(evaluate("(2 * 2) ^ 5")).to eq(1024)
    expect(evaluate("2 * 2 % 5")).to eq(4)
    expect(evaluate("2 * 4 / 3")).to be_within(0.001).of(2.66666666666667)
  end

  it "should have the correct values when using variables" do
    subject = MathEngine.new
    # expect(subject.evaluate("x = 1 * 2")).to eq(2)
    # expect(subject.evaluate("x + 1")).to eq(3)

    expect(subject.evaluate("i = 2 * 2")).to eq(4)
    expect(subject.evaluate("i + 1")).to eq(5)
  end

  it "should be able to call functions and use the result in calculations" do
    subject = MathEngine.new
    subject.context.define(:double_it, lambda { |x| x * 2 })
    subject.context.define(:add_em, lambda { |x, y| x + y })
    expect(subject.evaluate("10 * double_it(2)")).to eq(40)
    expect(subject.evaluate("10 * double_it(2 * 4 / 3)")).to be_within(0.001).of(53.3333333334)
    expect(subject.evaluate("10 * double_it(2 * 4 / 3 + (5 ^ 5))")).to be_within(0.001).of(62553.333333)
    expect(subject.evaluate("double_it(5) + add_em(10, add_em(2.5, 2.5)) + 5 + add_em(20, 20)")).to eq(70)
  end
end
