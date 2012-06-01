class MathEngine
  module Evaluators
    def self.find_by_name(name)
      class_name = name.to_s.sub(%r{^[a-z\d]}) { $&.upcase }
      class_name.gsub!(%r{(?:_|(\/))([a-z\d]*)}) { "#{$1}#{$2.capitalize}" }
      MathEngine::Evaluators.const_get(class_name) rescue raise MathEngine::UnknownEvaluatorError.new(name, "MathEngine::Evaluators::#{class_name}")
    end
  end
end