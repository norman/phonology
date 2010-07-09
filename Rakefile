require "rake/testtask"
require "rake/gempackagetask"
require "rake/clean"
require 'rake/rdoctask'

CLEAN << "pkg" << "doc" << "coverage" << ".yardoc" << "rdoc"

task :default => :test

Rake::TestTask.new(:test) { |t| t.pattern = "test/**/*_test.rb" }
Rake::GemPackageTask.new(eval(File.read("phonology.gemspec"))) { |pkg| }

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.options = ["--output-dir=doc"]
  end
rescue LoadError
end

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = 'rdoc'
end

begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
  end
rescue LoadError
end
