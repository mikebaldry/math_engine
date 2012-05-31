require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

class RandomlyNamedNode < MathEngine::Node ; end
module AnotherTest
  class RandomlyNamedNode < MathEngine::Node ; end
  module AndAgain
    class RandomlyNamedNode < MathEngine::Node ; end
  end
end


class MockEvaluator
  attr_reader :call_list
  
  def initialize
    @call_list = []
  end
  
  def method_missing(name, *args, &block)
    @call_list << {name: name, args: args}
  end
end

describe "Node evaluation against the evaluator" do
  it "should call the correct method on the evaluator based on its own name when not in a module" do
    evaluator = MockEvaluator.new
    node = RandomlyNamedNode.new(Object.new)
    node.evaluate(evaluator)
    evaluator.call_list.should == [{name: :randomly_named, args: [node]}]
  end
  
  it "should call the correct method on the evaluator based on its own name when in a module" do
    evaluator = MockEvaluator.new
    node = AnotherTest::RandomlyNamedNode.new(Object.new)
    node.evaluate(evaluator)
    evaluator.call_list.should == [{name: :randomly_named, args: [node]}]
  end
  
  it "should call the correct method on the evaluator based on its own name when in a module multiple levels deep" do
    evaluator = MockEvaluator.new
    node = AnotherTest::AndAgain::RandomlyNamedNode.new(Object.new)
    node.evaluate(evaluator)
    evaluator.call_list.should == [{name: :randomly_named, args: [node]}]
  end
end