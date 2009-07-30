require 'rake/rdoctask'
require 'cucumber'
require 'cucumber/rake/task'

desc "Default: run all tests"
task :default => [ 'features' ] 

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc")
  rd.rdoc_dir = 'doc/rdoc'
end
