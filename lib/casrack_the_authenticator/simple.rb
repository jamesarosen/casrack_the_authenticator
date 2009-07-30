require 'rack'
require 'rack/request'

module CasrackTheAuthenticator
  
  class Simple
    
    def initialize(app, options)
      @app = app
      @options = options
      raise ArgumentError.new(":cas_server is a required option") if options[:cas_server].nil?
    end
    
    def call(env)
      response = @app.call(env)
      redirect_on_401(env, response)
    end
    
    private
    
    def redirect_on_401(env, response)
      if response[0] == 401
        redirect_to_cas(env)
      else
        response
      end
    end
    
    def redirect_to_cas(env)
      [ 302, { 'Location' => cas_url(env) }, [] ]
    end
    
    def cas_url(env)
      url = @options[:cas_server].dup
      url << (url.include?('?') ? '&' : '?')
      url << 'service='
      url << Rack::Utils.escape(service_url(env))
    end
    
    def service_url(env)
      strip_ticket_param Rack::Request.new(env).url
    end
    
    def strip_ticket_param(url)
      url.sub(/[\?&]ticket=[^\?&]+/, '')
    end
    
  end
  
end
