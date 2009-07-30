require 'rack'
require 'rack/request'

module CasrackTheAuthenticator
  
  # The most basic CAS client use-case: redirects to CAS
  # if a middleware or endpoint beneath this one returns
  # a 401 response. On successful redirection back from 
  # CAS, puts the username of the CAS user in the session
  # under <tt>:cas_user</tt>.
  #
  # See CasrackTheAuthenticator::Configuration for
  # configuration options.
  class Simple
    
    def initialize(app, options)
      @app = app
      @configuration = CasrackTheAuthenticator::Configuration.new(options)
    end
    
    def call(env)
      request = Rack::Request.new(env)
      process_return_from_cas(request)
      redirect_on_401(request, @app.call(env))
    end
    
    private
    
    # ticket processing
    
      def process_return_from_cas(request)
        ticket = request.params['ticket']
        if ticket
          validator = ServiceTicketValidator.new(@configuration, service_url(request), ticket)
          request.session[:cas_user] = validator.user
        end
      end
    
    # redirection
    
      def redirect_on_401(request, response)
        if response[0] == 401
          redirect_to_cas(request)
        else
          response
        end
      end
    
      def redirect_to_cas(request)
        service_url = service_url(request)
        [ 302, { 'Location' => @configuration.login_url(service_url) }, [] ]
      end
    
    # utils  
    
      def service_url(request)
        strip_ticket_param request.url
      end
    
      def strip_ticket_param(url)
        url.sub(/[\?&]ticket=[^\?&]+/, '')
      end
    
  end
  
end
