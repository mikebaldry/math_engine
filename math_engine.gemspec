# -*- encoding: utf-8 -*-
# stub: math_engine 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "math_engine".freeze
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Baldry".freeze]
  s.date = "2017-02-24"
  s.description = "Lightweight matematical expression parser that is easy to extend".freeze
  s.email = "mikeyb@buyapowa.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze, "lib/context.rb".freeze, "lib/errors.rb".freeze, "lib/evaluators/calculate.rb".freeze, "lib/evaluators/finders.rb".freeze, "lib/lexer.rb".freeze, "lib/math_engine.rb".freeze, "lib/nodes.rb".freeze, "lib/parser.rb".freeze]
  s.homepage = "http://tech.buyapowa.com".freeze
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Lightweight mathematical expression parser".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<lexr>.freeze, [">= 0.4.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<lexr>.freeze, [">= 0.4.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<lexr>.freeze, [">= 0.4.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
