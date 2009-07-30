require 'uri'
require 'rack'
require 'rack/utils'

module CasrackTheAuthenticator
  
  class Configuration
    
    DEFAULT_LOGIN_URL = "%s/login"
    
    DEFAULT_SERVICE_VALIDATE_URL = "%s/serviceValidate"
    
    # Options:
    # 
    # [<tt>:cas_server</tt>] the CAS server root URL; probably something like
    #                        'http://cas.mycompany.com' or 
    #                        'http://cas.mycompany.com/cas'; optional
    # [<tt>:cas_login_url</tt>] the URL to which to redirect to for logins; 
    #                           optional if <tt>:cas_server</tt> is specified,
    #                           otherwise requred.
    # [<tt>:cas_service_validate_url</tt>] the URL to use for validating service tickets; 
    #                                      optional if <tt>:cas_server</tt> is specified,
    #                                      otherwise requred.
    def initialize(params)
      parse_params params
    end
    
    # Build a CAS login URL from +service+.
    # 
    # The result will look something like "http://cas.mycompany.com/login?service=..."
    def login_url(service)
      append_service @login_url, service
    end
    
    # Build a service-validation URL from +service+ and +ticket+.
    #
    # The result will look something like "http://cas.mycompany.com/serviceValidate?service=...&ticket=..."
    def service_validate_url(service, ticket)
      url = append_service @service_validate_url, service
      url << '&ticket=' << Rack::Utils.escape(ticket)
    end
    
    private
    
    def parse_params(params)
      if params[:cas_server].nil? && params[:cas_login_url].nil?
        raise ArgumentError.new(":cas_server or :cas_login_url MUST be provided")
      end
      @login_url   = params[:cas_login_url]
      @login_url ||= DEFAULT_LOGIN_URL % params[:cas_server]
      validate_is_url 'login URL', @login_url
      
      if params[:cas_server].nil? && params[:cas_service_validate_url].nil?
        raise ArgumentError.new(":cas_server or :cas_service_validate_url MUST be provided")
      end
      @service_validate_url   = params[:cas_service_validate_url]
      @service_validate_url ||= DEFAULT_SERVICE_VALIDATE_URL % params[:cas_server]
      validate_is_url 'service-validate URL', @service_validate_url
    end
    
    IS_NOT_URL_ERROR_MESSAGE = "%s is not a valid URL"
    
    def validate_is_url(name, possibly_a_url)
      url = URI.parse(possibly_a_url) rescue nil
      raise ArgumentError.new(IS_NOT_URL_ERROR_MESSAGE % name) unless url.kind_of?(URI::HTTP)
    end
    
    def append_service(base, service)
      result = base.dup
      result << (result.include?('?') ? '&' : '?')
      result << 'service='
      result << Rack::Utils.escape(service)
    end
    
  end
  
end
