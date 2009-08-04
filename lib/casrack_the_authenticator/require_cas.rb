module CasrackTheAuthenticator
  
  class RequireCAS
    
    # Create a new RequireCAS middleware, which requires
    # users to log in via CAS for _all_ requests, and
    # returns a 401 Unauthorized if they aren't signed in.
    #
    # @param app the underlying Rack app.
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if signed_in?(env)
        @app.call(env)
      else
        unauthorized
      end
    end
    
    private
    
    # @return [true, false] whether the user is signed in via CAS.
    def signed_in?(env)
      !Rack::Request.new(env).session[CasrackTheAuthenticator::USERNAME_PARAM].nil?
    end
    
    # @return [Array<Integer, Hash, String>] a 401 Unauthorized Rack response.
    def unauthorized
      [401, {}, "CAS Authentication is required"]
    end
    
  end
  
end
