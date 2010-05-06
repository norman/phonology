require File.expand_path("../lib/phonology/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "phonology"
  s.version      = Phonology::VERSION
  s.authors      = ["Norman Clarke"]
  s.email        = "norman@njclarke.com"
  s.homepage     = "http://github.com/norman/phonology"
  s.summary      = "Phonology library for Ruby"
  s.description  = "A phonology library for Ruby."
  s.files        = `git ls-files {test,lib}`.split("\n") + %w(README.md LICENSE)
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
