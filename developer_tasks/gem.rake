require 'rake/gempackagetask'

spec = eval File.read('casrack_the_authenticator.gemspec')

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

namespace :pkg do
  
  pkg_dir = File.join(CASRACK_PROJECT_ROOT, 'pkg')
  
  desc "clean the pkg/ director"
  task :clean do
    rm_r pkg_dir if File.exists?(pkg_dir)
  end
  
end
