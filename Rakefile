require 'rake'

CASRACK_PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
Dir[CASRACK_PROJECT_ROOT + "/developer_tasks/*.rake"].each { |f| load(f) }

desc "Default: run all tests, including features"
task :default => ['test']
