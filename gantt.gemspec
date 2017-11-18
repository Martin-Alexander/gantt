$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gantt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gantt"
  s.version     = Gantt::VERSION
  s.authors     = ["Martin-Alexander"]
  s.email       = ["martingianna@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Gantt."
  s.description = "TODO: Description of Gantt."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
