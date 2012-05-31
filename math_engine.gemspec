Spec = Gem::Specification.new do |s|

  # Change these as appropriate
   s.name = "math_engine"
   s.version = "0.3.0"
   s.summary = "Evaluates mathematical expressions"
   s.author = "Michael Baldry"
   s.email = "michael.baldry@uswitch.com"
   s.homepage = "http://www.forwardtechnology.co.uk"
 
   s.has_rdoc = true
   s.extra_rdoc_files = %w(README.md)
   s.rdoc_options = %w(--main README.md)
  
   # Add any extra files to include in the gem (like your README)
   s.files = %w(README.md) + Dir.glob("{spec,lib/**/*}")
   s.require_paths = ["lib"]
                            
   s.add_dependency('lexr', '>= 0.2.2')
  
   # If your tests use any gems, include them here
   s.add_development_dependency("rspec")
end
