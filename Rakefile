require "rubygems"
require "rubygems/package_task"
require "rdoc/task"

require "spec"
require "spec/rake/spectask"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(--format specdoc --colour)
  t.libs = ["spec"]
end


task :default => ["spec"]

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
# http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name = "math_engine"
  s.version = "0.6.0"
  s.summary = "Lightweight mathematical expression parser"
  s.description = "Lightweight matematical expression parser that is easy to extend"
  s.author = "Michael Baldry"
  s.email = "michael@brightbits.co.uk"
  s.homepage = "http://www.brightbits.co.uk"

  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md)
  s.rdoc_options = %w(--main README.md)

  # Add any extra files to include in the gem (like your README)
  s.files = %w(README.md) + Dir.glob("{spec,lib/**/*}")
  s.require_paths = ["lib"]
  
  s.add_dependency('lexr', '>= 0.3.0')

  # If your tests use any gems, include them here
  s.add_development_dependency("rspec")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

task :package => :gemspec

# Generate documentation
Rake::RDocTask.new do |rd|
  
  rd.rdoc_files.include("lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
