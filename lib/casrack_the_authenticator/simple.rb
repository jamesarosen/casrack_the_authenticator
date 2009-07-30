module CasrackTheAuthenticator
  
  class Simple
    
    def initialize(app, options)
      @app = app
      @options = options
      raise ArgumentError.new(":cas_server is a required option") if options[:cas_server].nil?
    end
    
    def call(env)
      response = @app.call(env)
      redirect_on_401(response)
    end
    
    private
    
    def redirect_on_401(response)
      if response[0] == 401
        redirect_to_cas
      else
        response
      end
    end
    
    def redirect_to_cas
      [ 302, { 'Location' => @options[:cas_server] }, [] ]
    end
    
  end
  
end
