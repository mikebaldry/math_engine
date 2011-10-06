# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{math_engine}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Baldry}]
  s.date = %q{2011-10-06}
  s.email = %q{michael.baldry@uswitch.com}
  s.extra_rdoc_files = [%q{README.md}]
  s.files = [%q{README.md}, %q{spec}, %q{lib/lexer.rb}, %q{lib/parser.rb}, %q{lib/math_engine.rb}, %q{lib/nodes.rb}, %q{lib/errors.rb}]
  s.homepage = %q{http://www.forwardtechnology.co.uk}
  s.rdoc_options = [%q{--main}, %q{README.md}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Evaluates mathematical expressions}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<lexr>, [">= 0.2.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<lexr>, [">= 0.2.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<lexr>, [">= 0.2.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
