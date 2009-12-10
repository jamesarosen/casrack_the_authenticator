require 'nokogiri'
require 'net/http'
require 'net/https'

module CasrackTheAuthenticator
  
  class ServiceTicketValidator
    
    VALIDATION_REQUEST_HEADERS = { 'Accept' => '*/*' }
    
    # Build a validator from a +configuration+, a
    # +return_to+ URL, and a +ticket+.
    #
    # @param [CasrackTheAuthenticator::Configuration] configuration the CAS configuration
    # @param [String] return_to_url the URL of this CAS client service
    # @param [String] ticket the service ticket to validate
    def initialize(configuration, return_to_url, ticket)
      @uri = URI.parse(configuration.service_validate_url(return_to_url, ticket))
    end
    
    # Request validation of the ticket from the CAS server's
    # serviceValidate (CAS 2.0) function.
    #
    # Swallows all XML parsing errors (and returns +nil+ in those cases).
    #
    # @return [String, nil] a username if the response is valid; +nil+ otherwise.
    #
    # @raise any connection errors encountered.
    def user
      parse_user(get_validation_response_body)
    end
    
    private
    
    def get_validation_response_body
      result = ''
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = @uri.scheme == 'https'
      http.start do |c|
        response = c.get "#{@uri.path}?#{@uri.query}", VALIDATION_REQUEST_HEADERS
        result = response.body
      end
      result
    end
    
    def parse_user(body)
      begin
        doc = Nokogiri::XML(body)
        node   = doc.xpath('/cas:serviceResponse/cas:authenticationSuccess/cas:user').first
        node ||= doc.xpath('/serviceResponse/authenticationSuccess/user').first  # try w/o the namespace just in case
        node.nil? ? nil : node.content
      rescue Nokogiri::XML::XPath::SyntaxError
        nil
      end
    end
    
  end
  
end