require 'yard'
require 'yard/rake/yardoc_task'

desc "Generate RDoc"
task :doc => ['doc:generate']

namespace :doc do
  
  doc_dir = File.join(CASRACK_PROJECT_ROOT, 'doc', 'rdoc')
  
  YARD::Rake::YardocTask.new(:generate) do |yt|
    yt.files   = Dir.glob(File.join(CASRACK_PROJECT_ROOT, 'lib', '**', '*.rb')) + 
                 [ File.join(CASRACK_PROJECT_ROOT, 'README.rdoc') ]
    yt.options = ['--output-dir', doc_dir, '--readme', 'README.rdoc']
  end
  
  desc "Remove generated documenation"
  task :clean do
    rm_r doc_dir if File.exists?(doc_dir)
  end
  
end