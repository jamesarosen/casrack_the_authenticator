require 'rack'
require 'rack/auth/basic'

module CasrackTheAuthenticator
  
  # A fake CAS authenticator.  Good for disconnected-mode
  # development.
  class Fake
    
    BASIC_AUTH_401 = [
      401,
      {
        'Content-Type' => 'text/plain',
        'Content-Length' => '0',
        'WWW-Authenticate' => 'Basic realm="CasrackTheAuthenticator::Fake"'
      },
      []
    ]
    
    # @param app the underlying Rack application
    # @param [Array<String>] usernames an Array of usernames that
    #        will successfully authenticate as though they
    #        had come from CAS.
    def initialize(app, *usernames)
      @app, @usernames = app, usernames
      raise "Why would you create a Fake CAS authenticator but not let anyone use it?" if usernames.empty?
    end
    
    def call(env)
      process_basic_auth(env)
      basic_auth_on_401(@app.call(env))
    end
    
    private
    
    def process_basic_auth(env)
      auth = Rack::Auth::Basic::Request.new(env)
      if auth.provided? && auth.basic? && @usernames.include?(auth.username)
        Rack::Request.new(env).session[CasrackTheAuthenticator::USERNAME_PARAM] = auth.username
      end
    end
    
    def basic_auth_on_401(response)
      response[0] == 401 ? BASIC_AUTH_401 : response
    end
    
  end
  
end
