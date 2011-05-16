# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "Report Engine"
  s.summary = "Generate reports for model by simply add some dsl config."
  s.description = "Generate reports for model by simply add some dsl config."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"
end