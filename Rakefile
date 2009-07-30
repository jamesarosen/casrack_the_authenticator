desc "Default: run all tests, including features"
task :default => [ 'test', 'features' ] 

# PACKAGING

require 'rake/gempackagetask'

spec = eval File.read('casrack_the_authenticator.gemspec')

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

# DOCUMENTATION

require 'yard'
require 'yard/rake/yardoc_task'

desc "Generate RDoc"
task :doc => ['doc:generate']

namespace :doc do
  
  doc_dir = './doc/rdoc'
  
  YARD::Rake::YardocTask.new(:generate) do |yt|
    yt.files   = ['lib/**/*.rb', 'README.rdoc']
    yt.options = ['--output-dir', doc_dir]
  end
  
  desc "Remove generated documenation"
  task :clean do
    rm_r doc_dir if File.exists?(doc_dir)
  end
  
end

# TESTING

require 'cucumber'
require 'cucumber/rake/task'
require 'rake/testtask'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
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