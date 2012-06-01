require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Finding evaluators by name" do
  it "should by able to find the calculate evaluator" do
    MathEngine::Evaluators.find_by_name(:calculate).should == MathEngine::Evaluators::Calculate
  end
  
  it "should raise an error if unable to find the evaluator" do
    lambda { MathEngine::Evaluators.find_by_name(:not_there) }.should raise_error MathEngine::UnknownEvaluatorError.new(:not_there, "MathEngine::Evaluators::NotThere")
  end
end