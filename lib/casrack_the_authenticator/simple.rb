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
      request = Rack::Request.new(env)
      redirect_on_401(request, @app.call(env))
    end
    
    private
    
    def redirect_on_401(request, response)
      if response[0] == 401
        redirect_to_cas(request)
      else
        response
      end
    end
    
    def redirect_to_cas(request)
      [ 302, { 'Location' => cas_url(request) }, [] ]
    end
    
    def cas_url(request)
      url = @options[:cas_server].dup
      url << (url.include?('?') ? '&' : '?')
      url << 'service='
      url << Rack::Utils.escape(service_url(request))
    end
    
    def service_url(request)
      strip_ticket_param request.url
    end
    
    def strip_ticket_param(url)
      url.sub(/[\?&]ticket=[^\?&]+/, '')
    end
    
  end
  
end
