$:.push File.expand_path("../lib", __FILE__)
require "falu/version"

Gem::Specification.new do |s|
  s.name        = "falu"
  s.version     = Falu::Version::VERSION
  s.summary     = "Extract color swatches from images with imagemagick"
  s.description = "Extract color swatches and full palettes from images with imagemagick"
  s.authors     = ["Mark Rebec"]
  s.email       = ["mark@markrebec.com"]
  s.homepage    = "http://github.com/markrebec/falu"

  s.files       = Dir["colors.txt", "lib/**/*"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "canfig"
  s.add_dependency "mini_magick" # TODO allow using any imagemagick ruby bindings
  s.add_dependency "activesupport"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
