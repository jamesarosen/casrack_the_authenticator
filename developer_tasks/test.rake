require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

LIB_DIRECTORIES = FileList.new do |fl|
  fl.include "#{CASRACK_PROJECT_ROOT}/lib"
  fl.include "#{CASRACK_PROJECT_ROOT}/test/lib"
end
 
TEST_FILES = FileList.new do |fl|
  fl.include "#{CASRACK_PROJECT_ROOT}/test/**/*_test.rb"
  fl.exclude "#{CASRACK_PROJECT_ROOT}/test/test_helper.rb"
  fl.exclude "#{CASRACK_PROJECT_ROOT}/test/lib/**/*.rb"
end

Rake::TestTask.new(:test) do |t|
  t.libs = LIB_DIRECTORIES
  t.test_files = TEST_FILES
  t.verbose = true
end
