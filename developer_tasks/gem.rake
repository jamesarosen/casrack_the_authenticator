begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "casrack_the_authenticator"
    gemspec.summary = "CAS Authentication via Rack Middleware"
    gemspec.description = gemspec.summary
    gemspec.email = "james.a.rosen@gmail.com"
    gemspec.homepage = "http://github.com/gcnovus/casrack_the_authenticator"
    gemspec.authors = ["James Rosen"]
    gemspec.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Casrack the Authenticator: RDoc", "--charset", "utf-8"]
    gemspec.platform = Gem::Platform::RUBY
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
