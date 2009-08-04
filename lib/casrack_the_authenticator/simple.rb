require 'rack'
require 'rack/request'

module CasrackTheAuthenticator
  
  # The most basic CAS client use-case: redirects to CAS
  # if a middleware or endpoint beneath this one returns
  # a 401 response. On successful redirection back from 
  # CAS, puts the username of the CAS user in the session
  # under <tt>:cas_user</tt>.
  class Simple
    
    # Create a new CAS middleware.
    # 
    # @param app the underlying Rack application
    # @param [Hash] options - see
    #               CasrackTheAuthenticator::Configuration
    #               for more information
    def initialize(app, options)
      @app = app
      @configuration = CasrackTheAuthenticator::Configuration.new(options)
    end
    
    # Processes the CAS user if a "ticket" parameter is passed,
    # then calls the underlying Rack application; if the result
    # is a 401, redirects to CAS; otherwise, returns the response
    # unchanged.
    #
    # @return [Array<Integer, Hash, #each>] a Rack response
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
          request.session[CasrackTheAuthenticator::USERNAME_PARAM] = validator.user
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
