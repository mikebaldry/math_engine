Gem::Specification.new do |s|
  s.name              = "math_engine"
  s.version           = "0.3.0"
  s.summary           = "Evaluates mathematical expressions"
  s.author            = "Mario de la Ossa"
  s.email             = "mariodelaossa@gmail.com"
  s.homepage          = "https://github.com/mdelaossa/math_engine"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.md)
  s.rdoc_options      = %w(--main README.md)

  # Add any extra files to include in the gem (like your README)
  s.files             = %w(README.md) + Dir.glob("{spec,lib/**/*}")
  s.require_paths     = ["lib"]
  
  s.add_dependency('lexr', '>= 0.2.2')
end
