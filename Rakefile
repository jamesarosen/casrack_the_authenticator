require 'rake/rdoctask'
require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'

desc "Default: run all tests, including features"
task :default => [ 'test', 'features' ] 

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = 'doc/rdoc'
end

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))

LIB_DIRECTORIES = FileList.new do |fl|
  fl.include "#{PROJECT_ROOT}/lib"
  fl.include "#{PROJECT_ROOT}/test/lib"
end
 
TEST_FILES = FileList.new do |fl|
  fl.include "#{PROJECT_ROOT}/test/**/*_test.rb"
  fl.exclude "#{PROJECT_ROOT}/test/test_helper.rb"
  fl.exclude "#{PROJECT_ROOT}/test/lib/**/*.rb"
end

Rake::TestTask.new(:test) do |t|
  t.libs = LIB_DIRECTORIES
  t.test_files = TEST_FILES
  t.verbose = true
end