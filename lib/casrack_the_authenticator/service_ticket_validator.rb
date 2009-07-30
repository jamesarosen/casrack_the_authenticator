require 'nokogiri'

module CasrackTheAuthenticator
  
  class ServiceTicketValidator
    
    VALIDATION_REQUEST_HEADERS = { 'Accept' => '*/*' }
    
    def initialize(configuration, return_to_url, ticket)
      @uri = URI.parse(configuration.service_validate_url(return_to_url, ticket))
    end
    
    def user
      parse_user(get_validation_response_body)
    end
    
    private
    
    def get_validation_response_body
      result = ''
      Net::HTTP.new(@uri.host, @uri.port).start do |c|
        response = c.get "#{@uri.path}?#{@uri.query}", VALIDATION_REQUEST_HEADERS
        result = response.body
      end
      result
    end
    
    def parse_user(body)
      begin
        doc = Nokogiri::XML(body)
        node = doc.xpath('/serviceResponse/authenticationSuccess/user').first
        node.nil? ? nil : node.content
      rescue Nokogiri::XML::XPath::SyntaxError
        nil
      end
    end
    
  end
  
end