module CasrackTheAuthenticator
  
  class Basic
    
    def initialize(app, options)
      @app = app
    end
    
    def call(env)
      @app.call(env)
    end
    
  end
  
end
