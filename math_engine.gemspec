# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "math_engine"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Baldry"]
  s.date = "2012-09-10"
  s.description = "Lightweight matematical expression parser that is easy to extend"
  s.email = "michael@brightbits.co.uk"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md", "spec", "lib/context.rb", "lib/errors.rb", "lib/evaluators", "lib/evaluators/calculate.rb", "lib/evaluators/finders.rb", "lib/lexer.rb", "lib/math_engine.rb", "lib/nodes.rb", "lib/parser.rb"]
  s.homepage = "http://www.brightbits.co.uk"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Lightweight mathematical expression parser"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<lexr>, [">= 0.3.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<lexr>, [">= 0.3.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<lexr>, [">= 0.3.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
