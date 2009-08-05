Gem::Specification.new do |s|

  s.name = "casrack_the_authenticator"
  s.version = "1.4.0"
  s.date = Time.now.strftime('%Y-%m-%d')
  
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{doc,lib,test,features}/**/*") + ['README.rdoc', 'Rakefile']
  s.require_paths = ['lib']
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Casrack the Authenticator: RDoc", "--charset", "utf-8"]

  s.summary = "CAS Authentication via Rack Middleware"
  s.description = s.summary
  s.authors = ["James Rosen"]
  s.email = "james.a.rosen@gmail.com"
  s.homepage = "http://github.com/gcnovus/casrack_the_authenticator"

end